#include <iostream>
#include <iomanip>
using namespace std;

#define ll long long
#define A 37
#define M 1000000007
#define max_s_len 500

int char_to_int(char c){
    return c - 'a' + 1;
}

int hash_fun(string s, int N, int A_pows[]){
    int s_hash = 0;
    for(int i = 0; i < N; i++){
        ll new_sum_elem = 1LL * char_to_int(s[i]) * A_pows[N-i];
        new_sum_elem %= M;
        s_hash = (s_hash + new_sum_elem) % M;
    }
    return s_hash;
}

int infix_hash_calculator(int b, int e, int prefix_hashes[], int A_pows[]){
    if(b == 0) return prefix_hashes[e];
    ll result = (prefix_hashes[e] - prefix_hashes[b-1]);
    result *= A_pows[b];
    result %= M;
    return (int)result;
}

int main(){
    //precalculating all A powers modulo M
    int A_powers_mod_M[max_s_len];
    A_powers_mod_M[0] = 1;
    for(int i = 1; i < max_s_len; i++){
        ll result = (1LL * A_powers_mod_M[i-1] * A) % M;
        A_powers_mod_M[i] = (int)result;
    }
    // //DEBUGb
    // for(int i = 0; i < max_s_len; i++){
    //     cout<<i<<": "<<A_powers_mod_M[i]<<"\n";
    // }
    // //DEBUGe

    int q;
    cin>>q;
    for(int i = 0; i < q; i++){
        string s, t;
        cin>>s>>t;

        int Slen = s.length();
        int Tlen = t.length();
        //calculating s prefixes hashes
        int s_prefix_hashes[Slen];
        string s_prefixes[Slen];
        s_prefix_hashes[0] = (1LL * char_to_int(s[0]) * A_powers_mod_M[Slen]) % M;
        s_prefixes[0] = s[0];
        for(int j = 1; j < Slen; j++){
            ll new_sum_elem = 1LL * char_to_int(s[j]) * A_powers_mod_M[Slen-j];
            new_sum_elem %= M;
            s_prefix_hashes[j] = (s_prefix_hashes[j-1] + new_sum_elem) % M;
            s_prefixes[j] = s_prefixes[j-1] + s[j];
        }
        // //DEBUGb
        // cout<<"s prefixes and their hashes\n";
        // for(int j = 0; j < Slen; j++){
        //     cout<<fixed<<setw(10);
        //     cout<<s_prefixes[j]<<"   ";
        // }
        // cout<<"\n";   
        // for(int j = 0; j < Slen; j++){
        //     cout<<fixed<<setw(10);
        //     cout<<s_prefix_hashes[j]<<"   ";
        // }
        // cout<<"\n\n";
        // //DEBUGe
                        

        //calculating t prefixes and reversed suffixes hashes
        int t_hashes[2][Tlen];
        //DEBUG
        string t_string_to_hash[2][Tlen];
        /*
        row 0 has prefix hashes beginning with the whole t string (the longest prefix)
        row 1 has reversed suffix hashes beginning with the empty string
        */
        t_hashes[0][Tlen-1] = (1LL * char_to_int(t[0]) * A_powers_mod_M[Slen]) % M;
        t_string_to_hash[0][Tlen-1] = t[0];
        for(int j = 1; j < Tlen; j++){
            ll new_sum_elem = 1LL * char_to_int(t[j]) * A_powers_mod_M[Slen-j];
            new_sum_elem %= M;            
            t_hashes[0][Tlen-1-j] = (t_hashes[0][Tlen-1-j+1] + new_sum_elem) % M;
            t_string_to_hash[0][Tlen-1-j] = t_string_to_hash[0][Tlen-1-j+1] + t[j];
        }
        t_hashes[1][0] = 0;
        if(Tlen > 1){
            t_hashes[1][1] = (1LL * char_to_int(t[Tlen-1]) * A_powers_mod_M[Slen]) % M;
        }
        t_string_to_hash[1][0] = "";
        if(Tlen > 1){
            t_string_to_hash[1][1] = t[Tlen-1];
        }
        for(int j = 2; j < Tlen; j++){
            ll new_sum_elem = 1LL * char_to_int(t[Tlen-1-j+1]) * A_powers_mod_M[Slen-j+1];
            new_sum_elem %= M;            
            t_hashes[1][j] = (t_hashes[1][j-1] + new_sum_elem) % M;
            t_string_to_hash[1][j] = t_string_to_hash[1][j-1] + t[Tlen-1-j+1];
        }
        // //DEBUGb
        // cout<<"t prefixes and reversed suffixes and their hashes\n";
        // for(int r = 0; r <= 1; r++){
        //     for(int c = 0; c < Tlen; c++){
        //         cout<<fixed<<setw(10);
        //         cout<<t_string_to_hash[r][c]<<"   ";
        //     }
        //     cout<<"\n";
        //     for(int c = 0; c < Tlen; c++){
        //         cout<<fixed<<setw(10);
        //         cout<<t_hashes[r][c]<<"   ";
        //     }
        //     cout<<"\n\n";
        // }
        // //DEBUGe

        //going throught every beginning and middle combination and checking if string t can be written down
        bool is_possible = false;
        for(int b = 0; b < Slen; b++){//beginning
            for(int m = b; m < Slen && m < b + Tlen; m++){//middle
                //calculating the ending index
                int e = m - (Tlen - (m - b + 1));//end
                if(e < 0) continue;

                //creating two new string which come from the moving chip to the right and left phases
                string n1 = "", n2 = "";//new strings number 1 and 2
                for(int j = b; j <= m; j++){
                    n1 += s[j];
                }
                // for(int j = m - 1; j >= e; j--){
                //     n2 += s[j];
                // }
                for(int j = e; j <= m - 1; j++){
                    n2 += s[j];
                }
                // //DEBUGb
                // cout<<"b: "<<b<<" m: "<<m<<" e: "<<e<<"\n";
                // cout<<"n1: "<<n1<<"\n"<<"n2: "<<n2<<"\n";
                // //DEBUGe

                //calculating those string hashes
                int n1_hash = infix_hash_calculator(b, m, s_prefix_hashes, A_powers_mod_M);
                int n2_hash = infix_hash_calculator(e, m-1, s_prefix_hashes, A_powers_mod_M);
                // //DEBUGb
                // cout<<"n1_hash: "<<n1_hash<<"\n"<<"n2_hash: "<<n2_hash<<"\n\n";
                // //DEBUGe                

                //comparing those hashes with appropriate hashes from the t string
                //Tlen - n1.length() is a collumn in t_hashes in which are hashes I have to compare with n1_hash and n2_hash
                // //DEBUGb
                // cout<<"is_possible: "<<is_possible<<"\n";
                // //DEBUGe
                if(n1_hash == t_hashes[0][Tlen - n1.length()]   &&   n2_hash == t_hashes[1][Tlen - n1.length()]){
                    is_possible = true;
                }
                // //DEBUGb
                // cout<<"comparing n1 to: "<<t_string_to_hash[0][Tlen - n1.length()]<<"\n";
                // cout<<"n1_hash: "<<n1_hash<<" "<<t_string_to_hash[0][Tlen - n1.length()]<<" hash: "<<t_hashes[0][Tlen - n1.length()]<<"\n";
                // cout<<"comparing n2 to: "<<t_string_to_hash[1][Tlen - n1.length()]<<"\n";
                // cout<<"n2_hash: "<<n2_hash<<" "<<t_string_to_hash[1][Tlen - n1.length()]<<" hash: "<<t_hashes[1][Tlen - n1.length()]<<"\n";
                // cout<<"is_possible: "<<is_possible<<"\n\n";
                // //DEBUGe
                if(is_possible) break;
            }
            if(is_possible) break;
        }
        if(is_possible) cout<<"YES\n";
        else cout<<"NO\n";
    }
}