#!/usr/bin/env python3

from siliconcompiler import Chip
from siliconcompiler.targets import fpgaflow_demo


def main():
    chip = Chip('pattern_matcher')

    chip.register_source("bobby-matcher", __file__)

    chip.input("pattern_matcher.v")#, package="bobby-matcher")
    chip.input("Arty-A7-100-Master.xdc")#, package="bobby-matcher")
    chip.set('fpga', 'partname', 'XC7A100TCSG324-1')

    chip.use(fpgaflow_demo)

    chip.set('option', 'remote', True)

    chip.run()
    chip.summary()


if __name__ == '__main__':
    main()