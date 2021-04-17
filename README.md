# AES
[The Advanced Encryption Standard (AES)](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) is the primary symmetric encryption and decryption mechanism used in many applications. 
***
The AES core is a cryptographic accelerator that is designed to support [AES-NI](https://en.wikipedia.org/wiki/AES_instruction_set) instructions and therefore it is built to be encapsulated in with  processor core in a single package. It has a simple ready-valid interface that can be easily extended.

The core is designed with both area and performance in mind. It has a datapath width of 128 bits for the minimal cycles per instruction count, and the mix columns operation as well as the byte substitution operation being optimised for a minimal area.
***
## Supported Instructions
Currently the core supports encryption operations only with decryption being added in future work. Also, key lengths 192 and 256 are not yet supported. 
The core supports an additional operation AESENCFULL which perfroms the the full 10 round encryption process.
|Operation| Description|
|---------|------------|
|NOOP|No Operation|
|AESENC|Encrypt Single Round|
|AESENCLAST|Encrypt Final Round|
|AESKEYGENASSIST|Generate Round Key|
|AESENCFULL|Complete 10 Round Encryption|

***
## References
The work in this project is heavily based on two papers:
* [Satoh et al.](https://www.researchgate.net/publication/225127628_A_Compact_Rijndael_Hardware_Architecture_with_S-Box_Optimization), "A Compact Rijndael Hardware Architecture with S-Box Optimization"
* [Nabihah Ahmad, S.M. Rezaul Hasan](https://www.researchgate.net/publication/259118946_Low-power_compact_composite_field_AES_S-BoxInv_S-Box_design_in_65_nm_CMOS_using_Novel_XOR_Gate), "Low-power compact composite field AES S-Box/Inv S-Box design in 65nm CMOS using Novel XOR Gate"
