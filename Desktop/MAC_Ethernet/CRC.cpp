#include <iostream>
#include <vector>
#include <cstdint>
#include <svdpi.h>

static uint32_t crc_state = 0xFFFFFFFF;
static const uint32_t poly = 0xEDB88320;

// Reset CRC state
extern "C" void crc32_reset() {
    crc_state = 0xFFFFFFFF;
}


// Update CRC with one 64-bit word (data comes LSB first like Ethernet usually)
extern "C" void crc32_update(uint64_t word, int valid_bytes) {
    unsigned char bytes[8];

    // Extract bytes (little-endian, Ethernet order)
    for (int i = 0; i < valid_bytes; i++) {
        bytes[i] = (word >> (8 * i)) & 0xFF;
    }

    // Process each byte exactly like crc32_ethernet()
    for (int i = 0; i < valid_bytes; i++) {
        crc_state ^= bytes[i];
        for (int j = 0; j < 8; j++) {
            if (crc_state & 1)
                crc_state = (crc_state >> 1) ^ poly;
            else
                crc_state >>= 1;
        }
    }
}


// Finalize CRC
extern "C" uint32_t crc32_finalize() {
    return crc_state ^ 0xFFFFFFFF;
}

