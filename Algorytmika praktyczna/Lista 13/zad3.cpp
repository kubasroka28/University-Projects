#include <iostream>
#include <vector>
using namespace std;

// alphabet size
const int ALPH_S = 26;
const int MOD = 1e9 + 7;

struct TrieNode {
    vector<TrieNode*> children;
    bool word_end_flag;

    TrieNode() : children(ALPH_S, NULL), word_end_flag(false) {}
};
using TNode = TrieNode*;

void add_word_to_tree(TNode root, string new_word){
    TNode node = root;
    for(char c : new_word){
        int index = c - 'a';
        if(node->children[index] == NULL){
            node->children[index] = new TrieNode();
        }
        node = node->children[index];
    }
    node->word_end_flag = true;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    string t;
    int k;
    cin>>t>>k;

    TNode TrieTree = new TrieNode();
    for(int i = 0; i < k; i++){
        string word;
        cin>>word;
        add_word_to_tree(TrieTree, word);
    }

    int n = t.size();
    vector<int> dp(n + 1, 0);
    dp[0] = 1; // pusty prefiks

    // DP + Trie traversal
    for(int i = 0; i < n; i++){
        if(dp[i] == 0) continue; // nic do dzielenia w tym miejscu

        TNode node = TrieTree;
        for(int j = i; j < n; j++){
            int index = t[j] - 'a';
            if(node->children[index] == NULL) break; // nie ma takiej ścieżki
            node = node->children[index];
            if(node->word_end_flag){
                dp[j + 1] += dp[i];
                if(dp[j + 1] >= MOD) dp[j + 1] -= MOD;
            }
        }
    }

    cout<<dp[n];

    return 0;
}
