#include <verilated.h>
#include "Vpattern_matcher.h"
#include <iostream>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);

    Vpattern_matcher *dut = new Vpattern_matcher;
    
    // Test cases
    struct TestCase {
        uint8_t pattern_a;
        uint8_t pattern_b;
        bool ground_truth;
    };
    
    TestCase test_cases[] = {
        {0b0000, 0b0000, true},
        {0b1111, 0b1111, true},
        {0b1010, 0b1010, true},
        {0b0000, 0b0001, false},
        {0b1000, 0b0001, false},
        {0b1111, 0b1110, false},
        {0b0101, 0b1010, false},
        {0b1100, 0b0011, false}
    };
    
    // Run tests
    for (int i = 0; i < sizeof(test_cases)/sizeof(TestCase); i++) {
        TestCase tc = test_cases[i];

        // Reset device
        dut->rst = 0;
        for (int i = 0; i < 2; i++) {
            dut->clk ^= 1;
            dut->eval();
        }
        dut->rst = 1;
        
        // Input patterns
        dut->pattern_a = tc.pattern_a;
        dut->pattern_b = tc.pattern_b;
        
        // Run the 4 cycles
        for (int j = 0; j < 4; j++) {
            dut->clk ^= 1;
            dut->eval();
            
            dut->clk ^= 1;
            dut->eval();
        }
        
        // Compare result with ground truth
        if (dut->match != tc.ground_truth) {
            std::cout << "Test " << (i + 1) << " failed: "
                      << "A=" << (int)tc.pattern_a << " B=" << (int)tc.pattern_b
                      << " Expected=" << tc.ground_truth
                      << " Got=" << dut->match << std::endl;
        } else {
            std::cout << "Test " << (i + 1) << " passed" << std::endl;
        }
    }

    delete dut;
    
    return 0;
}