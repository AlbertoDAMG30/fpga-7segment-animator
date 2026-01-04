# FPGA 7-Segment Display Animator

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![FPGA](https://img.shields.io/badge/FPGA-Nexys_A7-green)
![Platform](https://img.shields.io/badge/platform-Xilinx_Vivado-red)

## 📋 Description

A complete **7-segment display animation system** implemented in Verilog for the Nexys A7-100T FPGA board. The project displays a name ("DAVID") using three distinct dynamic animation patterns controlled by slide switches, demonstrating time-division multiplexing and clock division techniques.

Developed as Laboratory Project 2 for the EL-3310 Digital Systems Design course at Costa Rica Institute of Technology (TEC).

## 🎯 Key Features

### Display Modes
- ✅ **Static Display** - Name shown without animation
- ✅ **Animation 1** - Sequential letter appearance (fade-in effect)
- ✅ **Animation 2** - Bounce effect (left-right oscillation)
- ✅ **Animation 3** - Continuous scrolling (infinite loop)
- ✅ **Error Display** - Shows "ERROR" when multiple switches active

### Technical Implementation
- 🔄 **Time-division multiplexing** - 8 displays controlled individually
- ⏰ **Clock division** - Multiple frequencies from 100MHz base
- 🎮 **Switch control** - SW[0]=ON/OFF, SW[7-9]=Animation select
- 🚨 **Error handling** - Detects multiple simultaneous switches
- 📊 **Modular design** - Separate modules for each function

## 🛠️ Technologies Used

- **HDL**: Verilog (IEEE 1364-2005)
- **FPGA**: Nexys A7-100T (Artix-7 XC7A100T)
- **IDE**: Xilinx Vivado Design Suite
- **Target Device**: 7-segment common anode displays (8 digits)
- **Clock**: 100 MHz onboard oscillator

## 📦 Requirements

### Hardware
- Nexys A7-100T FPGA board
- USB cable for programming and power
- Computer with USB port

### Software
- Xilinx Vivado Design Suite (2018.2 or later)
- Windows/Linux OS
- Digilent board files for Nexys A7

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/AlbertoDAMG30/fpga-7segment-animator.git
cd fpga-7segment-animator
```

### 2. Open in Vivado
```
File → Project → Open Project
Select: fpga-7segment-animator/project.xpr
```

### 3. Synthesize and Implement
```
Flow → Run Synthesis
Flow → Run Implementation
Flow → Generate Bitstream
```

### 4. Program the FPGA
```
Flow → Open Hardware Manager
Open Target → Auto Connect
Program Device → Select bitstream file
```

## 📂 Project Structure

```
fpga-7segment-animator/
├── main.v                    # Top-level module
├── divisor_reloj.v          # Clock divider (100MHz → multiple frequencies)
├── multiplexor_nombre.v     # Static name display
├── animacion1.v             # Animation 1: Sequential appearance
├── animacion2.v             # Animation 2: Bounce effect
├── animacion3.v             # Animation 3: Continuous scroll
├── error_display.v          # Error message display
├── mostrar_A.v              # Single letter display (test module)
├── Proyecto2.v              # Original test module
├── Nexys-A7-100T-Master.xdc # Constraints file (pin mapping)
├── README.md                # This file
└── Proyectos_Lab2_IIS2025.pdf  # Project specifications (Spanish)
```

## 🎮 How to Use

### Switch Configuration

| Switch | Function |
|--------|----------|
| SW[0] | **Master ON/OFF** - Must be ON for any display |
| SW[7] | **Animation 1** - Sequential letter appearance |
| SW[8] | **Animation 2** - Bounce effect (left-right) |
| SW[9] | **Animation 3** - Continuous scrolling |

### Operating Modes

#### Mode 1: Static Display
```
SW[0] = ON
SW[7] = OFF
SW[8] = OFF
SW[9] = OFF
Result: "DAVID" displayed statically
```

#### Mode 2: Animation 1 (Sequential Appearance)
```
SW[0] = ON
SW[7] = ON
SW[8] = OFF
SW[9] = OFF
Result: Letters appear one by one from left to right
```

#### Mode 3: Animation 2 (Bounce)
```
SW[0] = ON
SW[7] = OFF
SW[8] = ON
SW[9] = OFF
Result: Name bounces left and right
```

#### Mode 4: Animation 3 (Scroll)
```
SW[0] = ON
SW[7] = OFF
SW[8] = OFF
SW[9] = ON
Result: Name scrolls continuously with spaces
```

#### Mode 5: Error
```
SW[0] = ON
Multiple animation switches ON (e.g., SW[7] AND SW[8])
Result: "Error" message displayed
```

#### Mode 6: All OFF
```
SW[0] = OFF
Result: All displays OFF
```

## 🧩 Module Descriptions

### main.v (Top Module)
- Instantiates all sub-modules
- Implements priority logic for mode selection
- Handles error detection
- Routes clock and control signals

### divisor_reloj.v (Clock Divider)
- Input: 100 MHz system clock
- Outputs:
  - `clk_slow`: ~6 kHz for multiplexing
  - `clk_anim1`: ~1.5 Hz for animation 1
  - `clk_anim2`: ~6 Hz for animation 2
  - `clk_anim3`: ~2 Hz for animation 3

### multiplexor_nombre.v (Static Display)
- Displays "DAVID" without animation
- Implements time-division multiplexing
- Cycles through 5 displays continuously

### animacion1.v (Sequential Appearance)
- Letters appear one at a time
- Starts with all blank
- Each clock cycle adds one letter
- Stops when all 5 letters visible

### animacion2.v (Bounce Effect)
- Name moves left and right
- Changes direction at boundaries
- Uses position offset to create motion
- Smooth oscillation effect

### animacion3.v (Continuous Scroll)
- Name scrolls from right to left
- Wraps around infinitely
- Spaces between repetitions
- Creates marquee effect

### error_display.v (Error Handler)
- Displays "Error" message
- Activates when multiple animation switches ON
- Static display (no animation)
- Uses 5 of 8 displays

## 🔧 Technical Details

### Clock Frequencies

| Signal | Frequency | Counter Bits | Purpose |
|--------|-----------|--------------|---------|
| `clk` | 100 MHz | N/A | System clock |
| `clk_slow` | ~6 kHz | [13] | Multiplexing |
| `clk_anim1` | ~1.5 Hz | [25] | Slow animation |
| `clk_anim2` | ~6 Hz | [23] | Fast animation |
| `clk_anim3` | ~2 Hz | [24] | Medium animation |

### 7-Segment Encoding

Letters are encoded as active-low signals (gfedcba):

| Letter | Encoding (binary) | Hex |
|--------|-------------------|-----|
| D | 0100001 | 0x21 |
| A | 0001000 | 0x08 |
| V | 1100011 | 0x63 |
| I | 1111011 | 0x7B |
| E | 0000110 | 0x06 |
| r | 0101111 | 0x2F |
| o | 1000000 | 0x40 |

### Anode Control

Active-low control for 8 displays (right to left):

```verilog
AN[7:0] = 8'b11111110  // Display 0 (rightmost)
AN[7:0] = 8'b11111101  // Display 1
AN[7:0] = 8'b11111011  // Display 2
...
AN[7:0] = 8'b01111111  // Display 7 (leftmost)
```

### Multiplexing Strategy

- **Refresh rate**: ~760 Hz per display (6kHz / 8)
- **Persistence**: >60 Hz to avoid flicker
- **Cycle time**: ~1.3 ms for all 8 displays

## 🎨 Animation Details

### Animation 1: Sequential Appearance
```
Frame 0: [    ]  (all blank)
Frame 1: [D    ]
Frame 2: [DA   ]
Frame 3: [DAV  ]
Frame 4: [DAVI ]
Frame 5: [DAVID]
```

### Animation 2: Bounce Effect
```
Position 0: DAVID    (leftmost)
Position 1:  DAVID
Position 2:   DAVID
Position 3:    DAVID
Position 4:     DAVID (rightmost)
Position 3:    DAVID  (bounce back)
Position 2:   DAVID
...
```

### Animation 3: Continuous Scroll
```
Time 0:     DAVID
Time 1:    DAVID 
Time 2:   DAVID  
Time 3:  DAVID   
Time 4: DAVID    
Time 5: AVID     D
Time 6: VID      DA
... (continues infinitely)
```

## 📊 Resource Utilization

Typical usage on Nexys A7-100T:

| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUTs | ~150 | 63,400 | <1% |
| Flip-Flops | ~80 | 126,800 | <1% |
| I/O Pins | 18 | 210 | ~9% |
| Clock Buffers | 1 | 32 | ~3% |

## 🐛 Troubleshooting

### All displays are OFF
- Check SW[0] is in ON position
- Verify FPGA is programmed correctly
- Check USB power connection

### Displays show random patterns
- Verify correct bitstream is loaded
- Check constraint file pin assignments
- Re-synthesize and re-program

### Animation doesn't work
- Ensure only ONE animation switch is ON
- Check SW[0] is ON
- Verify clock divider module

### "Error" shows unexpectedly
- Turn OFF multiple animation switches
- Only one of SW[7], SW[8], or SW[9] should be ON

### Displays flicker
- Normal for photography (camera shutter speed)
- Human eye should not perceive flicker
- If visible: check multiplexing frequency

## 📖 Design Principles

### Time-Division Multiplexing
- Single set of segment drivers (7 bits)
- 8 separate anode controls
- Rapidly cycle through displays
- Persistence of vision creates illusion of simultaneous display

### Clock Division
- 100 MHz too fast for visual effects
- Counter-based frequency dividers
- Multiple output frequencies for different animations
- No external components needed

### Modular Design
- Each animation in separate module
- Clock divider isolated
- Main module coordinates all
- Easy to add new animations

## 🏆 Project Requirements Compliance

### Mandatory Requirements ✅
- ✅ Nexys A7-100T FPGA board
- ✅ Verilog HDL implementation
- ✅ Xilinx Vivado toolchain
- ✅ 3 distinct dynamic animations
- ✅ Name displayed on 7-segment displays
- ✅ Switch-controlled operation
- ✅ Error handling for multiple switches
- ✅ Time-division multiplexing
- ✅ Clock frequency division

### Animations ✅
- ✅ Animation 1: Unique and dynamic
- ✅ Animation 2: Different from animation 1
- ✅ Animation 3: Different from both above
- ✅ All animations show name clearly
- ✅ No static frames (except error)

## 👨‍💻 Author

**David Alberto Miranda Gonzalez**
- Student ID: 2020207762
- Institution: Costa Rica Institute of Technology (TEC)
- Professor: Javier Rivera Alvarado
- Semester: I-2025

## 📄 License

This project was developed for educational purposes for the Digital Systems Design course at Costa Rica Institute of Technology.

## 🙏 Acknowledgments

- Digilent for Nexys A7 documentation and examples
- Xilinx for Vivado Design Suite
- TEC Digital Systems Lab for hardware resources

## 📚 References

- [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
- [Vivado Design Suite User Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug893-vivado-ide.pdf)
- [Verilog HDL Quick Reference](https://web.stanford.edu/class/ee183/handouts_win2003/VerilogQuickRef.pdf)

⭐ If you found this project helpful, give it a star on GitHub!
**Note**: This project demonstrates fundamental FPGA concepts including HDL programming, clock management, and display multiplexing. Perfect for learning digital design!
