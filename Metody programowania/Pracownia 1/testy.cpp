// max_pow actually says how many nodes I will add (take out from the list)

struct list = {
int val
struct
};

int build (list node_list, int max_pow){

    previous = Leaf;
    //int how_much_to_add = 1;

    for (int pow = 1; pow <= max_pow; pow++){
        previous = Node(previous, node_list.front(), build(node_list.pop_front(), pow - 1);
        //how_much_to_add *= 2;
    }
    return previous;
}

build(node_list, log List.len + 1);
