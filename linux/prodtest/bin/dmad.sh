#!/bin/bash

size="262144"  # set to 256k

# echo Testing Device 0, DDR0...
~/dna2_self_test_2_2_0/dma_test 0 ddr0 $size &> ~/prodtest/bin/foo-dma00
cat ~/prodtest/bin/foo-dma00 | \grep -i -E "passed|failed" > ~/prodtest/bin/bar-dma  # overwrite

# echo Testing Device 0, DDR1...
~/dna2_self_test_2_2_0/dma_test 0 ddr1 $size &> ~/prodtest/bin/foo-dma01
cat ~/prodtest/bin/foo-dma01 | \grep -i -E "passed|failed" >> ~/prodtest/bin/bar-dma  # append

# echo Testing Device 1, DDR0...
~/dna2_self_test_2_2_0/dma_test 1 ddr0 $size &> ~/prodtest/bin/foo-dma10
cat ~/prodtest/bin/foo-dma10 | \grep -i -E "passed|failed" >> ~/prodtest/bin/bar-dma  # append

# echo Testing Device 1, DDR1...
~/dna2_self_test_2_2_0/dma_test 1 ddr1 $size &> ~/prodtest/bin/foo-dma11
cat ~/prodtest/bin/foo-dma11 | \grep -i -E "passed|failed" >> ~/prodtest/bin/bar-dma  # append

echo "00 01 10 11"

# EOF
