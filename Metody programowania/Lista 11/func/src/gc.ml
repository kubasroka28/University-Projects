(* # -*- mode: c; -*- *)

let gc = {|
// temporary heap (so we don't do real ptrs in C)
int new_heap[HEAP_SIZE];

// gc stats
int last_heap_ptr = 0;
unsigned int num_of_collections = 0;
long unsigned int num_of_allocated_cells = 0;
float avg_survival = 0.0;

void print_gc_stats()
{
  printf("------ GC stats ------\n");
  printf("total memory (cells): %ld\n", num_of_allocated_cells + heap_ptr);
  printf("num of collecitons:   %d\n", num_of_collections);
  if (num_of_collections == 0)
    printf("avg survival rate:    n/a\n");
  else
    printf("avg survival rate:    %.5f%%\n", 100.0 * avg_survival / num_of_collections);
}

int evacuate(int ptr)
{
  // kept separately, because these get overwritten with EVAC node
  int tag = heap[ptr-1];
  int fst_val = heap[ptr];

  // kept separately, as the ptr changes inside recursive evacuations
  int loc_heap_ptr = heap_ptr;

  switch(tag)
  {
    case EVAC:
      return fst_val;

    case INT:
    case BOOL:
    case UNIT:
      heap[ptr-1] = EVAC;
      heap[ptr] = loc_heap_ptr + 1;
      heap_ptr += 2;
      new_heap[loc_heap_ptr] = tag;
      new_heap[loc_heap_ptr+1] = fst_val; // copy value
      return loc_heap_ptr + 1;

    case PAIR:
      heap_ptr += 3;
      heap[ptr-1] = EVAC;
      heap[ptr] = loc_heap_ptr + 1;
      new_heap[loc_heap_ptr] = tag;
      new_heap[loc_heap_ptr+1] = evacuate(fst_val); // follow ptrs
      new_heap[loc_heap_ptr+2] = evacuate(heap[ptr+1]);
      return loc_heap_ptr + 1;

    default:
      heap[ptr-1] = EVAC;
      heap[ptr] = heap_ptr + 1;
      int env_size = tag - CLO;
      heap_ptr += env_size + 2;
      new_heap[loc_heap_ptr] = tag;
      new_heap[loc_heap_ptr+1] = fst_val; // copy body address
      for (int i = 0; i < env_size; i++)
        new_heap[loc_heap_ptr + i + 2] =
          evacuate(heap[ptr+1+i]); // follow ptrs
      return loc_heap_ptr + 1;
  }
}

void collect()
{
  // stats
  num_of_collections++;
  num_of_allocated_cells += heap_ptr - last_heap_ptr;

  heap_ptr = 0;

  // evacuate stack ptrs
  for (int i = 0; i <= stack_ptr; i++)
    stack[i] = evacuate(stack[i]);

  // evacuate env ptrs
  for (int i = 0; i <= env_ptr; i++)
    env[i] = evacuate(env[i]);

  // copy heap
  for (int i = 0; i < heap_ptr; i++)
    heap[i] = new_heap[i];

  // more stats
  last_heap_ptr = heap_ptr;
  avg_survival += (float)heap_ptr / (float)HEAP_SIZE;
}
|}
