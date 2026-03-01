#include <stdio.h>

#define n 7

int main()
{
    int Tab[]={2,1,1,3,4,2,1};
    int licznik=0; //liczy ile jest przedzialow z roznymi liczbami
    int CzyWystapilo[n+1];
    for(int i=0; i<=n; i++)
    {
        CzyWystapilo[i]=0;
    }

    int l=0, r=0;

    for(r=0; r<n; r++)
    {
        if(CzyWystapilo[Tab[r]]==1)
        {
            /*do
            {
                Tab[l]=0;
                l++;
            } while(Tab[l]!=Tab[r])*/

            while(Tab[l]!=Tab[r])
            {
                CzyWystapilo[Tab[l]]=0;
                l++;
            }
            CzyWystapilo[Tab[l]]=0;
            l++;
        }
        CzyWystapilo[Tab[r]]=1;

        licznik+=(r-l+1);
    }




    /*for(int i=0; i<n; i++)
    {
        for(int j=i; j<n; j++)
        {
            if(CzyWystapilo[Tab[j]-1]==1) break;
            CzyWystapilo[Tab[j]-1]=1;

            /*int warunek=1;

            for(int k=i; k<j; k++)
            {
                if(Tab[k]==Tab[j]) {warunek=0; break;}
            }
            if(warunek==0) break;*
            licznik++;
        }
    }*/

    printf("%d",licznik);

    return 0;
}
