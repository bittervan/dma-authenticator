// `timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 08/24/2023 03:47:50 PM
// // Design Name: 
// // Module Name: hash_engine
// // Project Name: 
// // Target Devices: 
// // Tool Versions: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Revision:
// // Revision 0.01 - File Created
// // Additional Comments:
// // 
// //////////////////////////////////////////////////////////////////////////////////


// module hash_engine(
//     input wire clk,
//     input wire [127:0] metadata,
//     input wire [127:0] key,
//     input wire [63:0] pointer,
//     input wire start,
//     output reg [31:0] hash,
//     output reg done
// );

//     // reg start_qarma = 0;
//     // reg []
//     // always @ (posedge clk) begin
//     //     if (start) begin
//     //         start_qarma <= 1;
//     //     end else begin
//     //         start_qarma <= 0;
//     //     end
//     // end


//     // QarmaMultiCycle dut (
//     //     .clock(clk),
//     //     .reset(reset),
//     //     .input_valid(input_valid),
//     //     .input_bits_encrypt(input_bits_encrypt),
//     //     .input_bits_keyh(keyh),
//     //     .input_bits_keyl(keyl),
//     //     .input_bits_tweak(tweak),
//     //     .input_bits_text(text),
//     //     .output_ready(ready),
//     //     .output_valid(ok),
//     //     .output_bits_result(result)
//     // );

//     reg [4:0] state;
//     localparam STATE_IDLE =     5'h1;
//     localparam STATE_START =    5'h2;
//     localparam STATE_WORK_1 =   5'h3;
//     localparam STATE_WORK_2 =   5'h4;
//     localparam STATE_WORK_3 =   5'h5;
//     localparam STATE_WORK_4 =   5'h6;
//     localparam STATE_WORK_5 =   5'h7;
//     // localparam STATE_WORK_2 =   5'h4;

//     reg [127:0] actual_metadata;
//     reg [127:0] actual_key;
//     reg [127:0] actual_pointer;

//     // reg [31:0] hash;

//     initial begin
//         hash <= 0;
//         done <= 0;
//         actual_key <= 0;
//         actual_metadata <= 0;
//         actual_pointer <= 0;
//         state <= STATE_IDLE;
//         // src1 <= 0;
//         // src2 <= 0;
//     end


//     always @ (posedge clk) begin
//         if (start) begin
//             actual_metadata <= metadata;
//             actual_key <= key;
//             actual_pointer <= pointer;
//             state <= STATE_START;
//             hash <= 0;
//         end else begin
//             if (state == STATE_START) begin
//                 hash <= actual_metadata[127:96] ^ actual_metadata[95:64];
//                 state <= STATE_WORK_1;
//             end else if (state == STATE_WORK_1) begin
//                 hash <= hash ^ actual_metadata[63:32];
//                 state <= STATE_WORK_2;
//             end else if (state == STATE_WORK_2) begin
//                 hash <= hash ^ actual_metadata[31:0];
//                 state <= STATE_WORK_3;
//             end else if (state == STATE_WORK_3) begin
//                 hash <= hash ^ actual_key[31:0];
//                 state <= STATE_WORK_4;
//             end else if (state == STATE_WORK_4) begin
//                 hash <= hash[31:16] ^ (actual_pointer[47:0] >> (actual_metadata[125:121]));
//                 state <= STATE_WORK_5;
//             end else if (state == STATE_WORK_5) begin
//                 hash <= hash[15:0];
//                 state <= STATE_IDLE;
//                 done <= 1;
//             end else begin
//                 state <= STATE_IDLE;
//                 done <= 0;
//             end
//         end
//     end

// endmodule

module hash_engine(
    input wire clk,
    input wire [127:0] metadata,
    input wire [127:0] key,
    input wire [63:0] pointer,
    input wire start,
    // output reg [31:0] hash,
    // output reg done
    output wire [15:0] hash,
    output wire done
);

    reg get_start = 0;
    reg start_qarma = 0;
    reg [127:0] actual_metadata = 0;
    always @ (posedge clk) begin
        if (start) begin
            get_start <= 1;
            actual_metadata <= metadata;
        end else begin
            get_start <= 0;
            actual_metadata <= actual_metadata;
        end

        if (get_start) begin
            start_qarma <= 1;
        end else begin
            start_qarma <= 0;
        end
    end

    wire [63:0] masked_pointer = (pointer >> actual_metadata[125:120]) << actual_metadata[125:120];
    wire [63:0] result;
    assign hash = result[15:0];

    QarmaMultiCycle dut (
        .clock(clk),
        .reset(0),
        .input_valid(start_qarma),
        .input_bits_encrypt(1),
        .input_bits_keyh(key[127:64]),
        .input_bits_keyl(key[63:0]),
        // .input_bits_tweak({actual_metadata[95:64], actual_metadata[127:96]} ^ {actual_metadata[31:0], actual_metadata[63:32]}),
        .input_bits_tweak( actual_metadata[127:64] ^ actual_metadata[63:0] ),
        .input_bits_text(masked_pointer),
        .output_ready(1),
        .output_valid(done),
        .output_bits_result(result)
    );


endmodule

