/*
 * Copyright 2020 Brian O'Dell
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

module bram #(
    parameter BRAM_ADDR_WIDTH = 9,
    parameter BRAM_DATA_WIDTH = 8
) (
    input clk,
    input [BRAM_ADDR_WIDTH-1:0] addr,
    input cs_n,
    input wr_n,
    input rd_n,
    input [BRAM_DATA_WIDTH-1:0] bram_data_in,
    output reg [BRAM_DATA_WIDTH-1:0] bram_data_out
);

  reg [BRAM_DATA_WIDTH-1:0] mem[(1<<BRAM_ADDR_WIDTH)-1:0];

`ifndef SYNTHESIS
  // Simulation only: start the memory and its output at 0, as the FPGA's
  // block RAM does. Without this the X values would spread through the
  // design's feedback loops.
  integer init_i;
  initial begin
    bram_data_out = 0;
    for (init_i = 0; init_i < (1 << BRAM_ADDR_WIDTH); init_i = init_i + 1) mem[init_i] = 0;
  end
`endif

  always @(posedge clk)
    if (cs_n == 1'b0) begin
      begin
        if (wr_n == 1'b0) mem[addr] <= bram_data_in;
        if (rd_n == 1'b0) bram_data_out <= mem[addr];
      end
    end

endmodule
