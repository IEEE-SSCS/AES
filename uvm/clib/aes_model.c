#include "aes_functions.h"

void aes_enc(
    enum opcode operation,
    unsigned char plain_text_i[4][4],
    unsigned char key_i[4][4],
    unsigned char rcon_i,

    unsigned char cipher_text_o[4][4],
    unsigned char key_o[4][4]
){
    //Intermediate Results
    unsigned char round_cipher[4][4];
    unsigned char round_key[4][4];

    int index;

    for (int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            round_key[i][j] = key_i[i][j];
        }
    }

    switch (operation){
        case AESENCFULL:    //Full encryption
            //ROUND ZERO
            aes_add_key(plain_text_i, round_cipher, key_i);

            for (int i = 0; i < 9; i++){
                aes_key_generation(round_key, round_key, i);
                aes_single_round(round_cipher, round_cipher, round_key);
            }

            //Final AES Round
            aes_key_generation(round_key, round_key, 9);
            aes_final_round(round_cipher, cipher_text_o, round_key);
            break;

        case AESENC:    //Single round encryption
            aes_single_round(plain_text_i, cipher_text_o, key_i);
            break;

        case AESENCLAST:
            aes_final_round(plain_text_i, cipher_text_o, key_i);
            break;

        case AESKEYGENASSIST:
            switch (rcon_i){
                case 0x01: index = 0; break;
                case 0x02: index = 1; break;
                case 0x04: index = 2; break;
                case 0x08: index = 3; break;
                case 0x10: index = 4; break;
                case 0x20: index = 5; break;
                case 0x40: index = 6; break;
                case 0x80: index = 7; break;
                case 0x1B: index = 8; break;
                case 0x36: index = 9; break;
            }
            aes_key_generation(key_i, key_o, index);
            break;

        case AESZERO:
            aes_add_key(plain_text_i, cipher_text_o, key_i);
            break;
    }
}

#ifndef DPI
int main()
{
    unsigned char rcon = 0x01;

    unsigned char cipher[4][4];
    unsigned char key_o[4][4];

    enum opcode operation_1;

    operation_1 = AESENCFULL;

    unsigned char text[4][4] = {
        {0x32, 0x88, 0x31, 0xe0},
        {0x43, 0x5a, 0x31, 0x37},
        {0xf6, 0x30, 0x98, 0x07},
        {0xa8, 0x8d, 0xa2, 0x34}};

    unsigned char key[4][4] = {
        {0x2b, 0x28, 0xab, 0x09},
        {0x7e, 0xae, 0xf7, 0xcf},
        {0x15, 0xd2, 0x15, 0x4f},
        {0x16, 0xa6, 0x88, 0x3c}};

    aes_enc(operation_1, text, key, rcon, cipher, key_o);

    printf("FINAL OUTPUT\n");
    aes_print(cipher);

    return 0;
}
#endif
