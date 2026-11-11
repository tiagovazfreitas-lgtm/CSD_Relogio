## Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Buttons (Reset, Hora, Minutos)
set_property -dict { PACKAGE_PIN N17    IOSTANDARD LVCMOS33 } [get_ports { reset }];
set_property -dict { PACKAGE_PIN P17    IOSTANDARD LVCMOS33 } [get_ports { btn_hour }];
set_property -dict { PACKAGE_PIN M17    IOSTANDARD LVCMOS33 } [get_ports { btn_min }];

## 7-Segment Displays (Algarismos)
set_property -dict { PACKAGE_PIN T10    IOSTANDARD LVCMOS33 } [get_ports { algarismo[0] }];
set_property -dict { PACKAGE_PIN R10    IOSTANDARD LVCMOS33 } [get_ports { algarismo[1] }];
set_property -dict { PACKAGE_PIN K16    IOSTANDARD LVCMOS33 } [get_ports { algarismo[2] }];
set_property -dict { PACKAGE_PIN K13    IOSTANDARD LVCMOS33 } [get_ports { algarismo[3] }];
set_property -dict { PACKAGE_PIN P15    IOSTANDARD LVCMOS33 } [get_ports { algarismo[4] }];
set_property -dict { PACKAGE_PIN T11    IOSTANDARD LVCMOS33 } [get_ports { algarismo[5] }];
set_property -dict { PACKAGE_PIN L18    IOSTANDARD LVCMOS33 } [get_ports { algarismo[6] }];
set_property -dict { PACKAGE_PIN H15    IOSTANDARD LVCMOS33 } [get_ports { algarismo[7] }];

## Anodes (an0 a an7)
set_property -dict { PACKAGE_PIN J17    IOSTANDARD LVCMOS33 } [get_ports { an0 }];
set_property -dict { PACKAGE_PIN J18    IOSTANDARD LVCMOS33 } [get_ports { an1 }];
set_property -dict { PACKAGE_PIN T9     IOSTANDARD LVCMOS33 } [get_ports { an2 }];
set_property -dict { PACKAGE_PIN J14    IOSTANDARD LVCMOS33 } [get_ports { an3 }];
set_property -dict { PACKAGE_PIN P14    IOSTANDARD LVCMOS33 } [get_ports { an4 }];
set_property -dict { PACKAGE_PIN T14    IOSTANDARD LVCMOS33 } [get_ports { an5 }];
set_property -dict { PACKAGE_PIN K2     IOSTANDARD LVCMOS33 } [get_ports { an6 }];
set_property -dict { PACKAGE_PIN U13    IOSTANDARD LVCMOS33 } [get_ports { an7 }];

## Switches, Botões extra e LEDs
set_property -dict { PACKAGE_PIN V10    IOSTANDARD LVCMOS33 } [get_ports { sw_enable_timer }]; 
set_property -dict { PACKAGE_PIN U11    IOSTANDARD LVCMOS33 } [get_ports { sw_display_mux }]; 
set_property -dict { PACKAGE_PIN U12    IOSTANDARD LVCMOS33 } [get_ports { sw_sel_alarm }];   
set_property -dict { PACKAGE_PIN H6     IOSTANDARD LVCMOS33 } [get_ports { sw_alarm }];
set_property -dict { PACKAGE_PIN J15    IOSTANDARD LVCMOS33 } [get_ports { wth_set }];   
set_property -dict { PACKAGE_PIN V14    IOSTANDARD LVCMOS33 } [get_ports { led_alarme }];      
set_property -dict { PACKAGE_PIN H17    IOSTANDARD LVCMOS33 } [get_ports { led_tomada }];
set_property -dict { PACKAGE_PIN M18    IOSTANDARD LVCMOS33 } [get_ports { btn_fast }];

##cronometro
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { sw_sel_crono }];
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { sw_crono_en }];
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { btn_crono_clear }];
