#include <iostream>  
int main(){
    for(int i = 0 ; i < 100; i++){
        static int a = 1;
        std::cout << a << " || ";
        a = !a;
        std::cout << a << std::endl;
    }
}
