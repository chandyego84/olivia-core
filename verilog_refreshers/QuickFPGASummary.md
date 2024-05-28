# A Brief Overview of [FPGAs](https://en.wikipedia.org/wiki/Field-programmable_gate_array)

1. Understand that FPGAs are buildable using transistors. Understand LUTs and how they make up FPGAs.
- Transistors typically have a collector, emitter, and base. It acts as a switch by using electrical signals -- can be set to 0 by being an insulator and set to 1 by being a conductor.
- [Silicon, semiconductor materials by doping](https://www.youtube.com/watch?v=33vbFFFn04k&t=735s&ab_channel=BenEater)
    - [MOSFETS](https://www.realdigital.org/doc/2b54ad2b01a1ecfe96402b147211cec2) - Field effect transistors operate in response to an electric field. nFET is conductive when the channel is fulle of negative charge carriers. pFET is conductive when the channel is full of positive charge carriers.
- Gates (AND, OR, NOT, NAND, NOR, etc.) abstract transistors and can be used to make more complex modules like adders.
- [Watch this guy yap about CLBs/LUTs and how they interact in an FPGA.](https://www.youtube.com/watch?v=FcJ6tPsB0Tw&ab_channel=YogeshMisra)

2. [ICs](https://www.ansys.com/blog/what-is-an-integrated-circuit) are just a collection of transistors in a nice reliable package.
- Digital ICs can be used for memory, data storage, or logic.
- Analog ICs process continuous signals (zero to full supply voltage). Ex., sound, light.
- ASICs perform a specific task efficiently unlike general purpose ICs. Ex., [ASIC Miner for bitcoin](https://www.investopedia.com/terms/a/asic.asp) that only generates hashes. 