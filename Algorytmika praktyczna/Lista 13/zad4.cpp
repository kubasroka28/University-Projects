#include <iostream>
#include <vector>

#define ll long long

using namespace std;

const int ALPH_S = 2;
const int max_num = 20; //2 ^ max_num is an upper cap

struct TrieNode {
    vector<TrieNode*> children;
    int words_below_counter;

    TrieNode() : children(ALPH_S, NULL), words_below_counter(0) {}
};
using TNode = TrieNode*;

void add_num_to_tree(TNode root, int new_num){
    TNode node = root;
    for(int i = max_num; i >= 0; i--){
        int index = (new_num >> i) & 1;
        if(node->children[index] == NULL){
            node->children[index] = new TrieNode();
        }
        node = node->children[index];
        node->words_below_counter++;
    }
}

int query(TNode root, int new_num, int k){
    int res = 0;
    for(int i = max_num; i >= 0; i--){
        if(root == NULL) break;
        int bit_num = (new_num >> i) & 1;
        int bit_k = (k >> i) & 1;
        if(bit_k){// Rozwazany bit k to 1
            if(bit_num){// Rozwazany bit new_num to 1
                root = root->children[0];
            }
            else{// Rozwazany bit new_num to 0
                root = root->children[1];
            }
        }
        else{// Rozwazany bit k to 0
            if(bit_num){// Rozwazany bit new_num to 1
                if(root->children[0] != NULL)
                    res += root->children[0]->words_below_counter;
                root = root->children[1];
            }
            else{// Rozwazany bit new_num to 0
                if(root->children[1] != NULL)
                    res += root->children[1]->words_below_counter;
                root = root->children[0];
            }
        }
    }
    if (root != NULL)
        res += root->words_below_counter;
    return res;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, k;
    cin>>n>>k;
    TNode TrieTree = new TrieNode();
    ll result = 0;
    for(int i = 0; i < n; i++){
        int x;
        cin>>x;
        result += query(TrieTree, x, k);
        add_num_to_tree(TrieTree, x);
    }
    cout<<result;

    return 0;
}


//int x;
//// k-ty bit liczby x
//(1 << k) & x
//
//
//
///*
//Nie budujemy calego trie na raz. Dodajemy po kolei slowa i
//*/
//
//
//void modiyr(ccetor<ll> &tree, int a, int bits)
//{
//
//int i = 1;
//    while(bits > 0)
//    {
//
//        Tree[i]++;
//
//        int leading_bit = (1 << (bits - 1_)) & a;
//        if(leading_bit)
//        {
//            i = i * 2 + 1;
//        }
//        else{
//            i *= 2;
//        }
//        bits--;
//    }
//    TREE[i]++;
//}
//
//ll quary(vector<ll> &TREE, int a, int k, int bits, const int size){
//    ll i = 1, res = 0;
//}

