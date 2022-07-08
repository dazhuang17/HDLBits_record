# Verilog Language -> More Verilog Features

## 37 Conditional ternary operator
<details>
<summary>详情</summary>

**三元条件运算符 ( ? : )**  

`(condition ? if_true : if_false)`  
一般而言，多用于多路复用器，在一行中选择两个值之一，而无需在组合 always 块内使用 if-then。  
示例：
```
(0 ? 3 : 5)     // This is 5 because the condition is false.
(sel ? b : a)   // A 2-to-1 multiplexer between a and b selected by sel.

always @(posedge clk)         // A T-flip-flop.
  q <= toggle ? ~q : q;

always @(*)                   // State transition logic for a one-input FSM
  case (state)
    A: next = w ? B : A;
    B: next = w ? A : B;
  endcase

assign out = ena ? q : 1'bz;  // A tri-state buffer

((sel[1:0] == 2'h0) ? a :     // A 3-to-1 mux
 (sel[1:0] == 2'h1) ? b :
                      c )
```

给定四个无符号数，求最小值。无符号数可以与标准比较运算符（a < b）进行比较。
使用条件运算符制作两路最小电路，然后将其中的一些组成一个四路最小电路。您可能需要一些线向量作为中间结果。  

**分析**  
无。

**答案**  
```
module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);//
    wire [7:0] intermediate_result1;
    wire [7:0] intermediate_result2;
    
    assign intermediate_result1 = a < b ? a: b;
    assign intermediate_result2 = c < d ? c: d;
    assign min = intermediate_result1 < intermediate_result2 ? intermediate_result1: intermediate_result2;

endmodule
```

</details>

## 38 Reduction operators
<details>
<summary>详情</summary>

您已经熟悉两个值之间的按位运算，例如 a & b 或 a ^ b。
有时，您想创建一个对一个向量的所有位进行操作的宽门，例如 (a[0] & a[1] & a[2] & a[3] ... )。就会很麻烦。  

归约运算符(Reduction Operators)可以对向量的每一位位进行AND，OR和XOR，产生一位输出：
```
&a [3：0] // AND:a[3]&a[2]&a[1]&a [0]相当于(a[3：0]== 4'hf)
|b [3：0] // OR: b[3]|b[2]|b[1]|b [0]相当于(b[3：0]!= 4'h0)
^c [2：0] // XOR:c[2]^c[1]^c[0]
```
当通过不完善的通道传输数据时，奇偶校验通常用作检测错误的简单方法。
创建一个电路，计算 8 位字节的奇偶校验位（这将向字节添加第 9 位）。
我们将使用`“偶数”奇偶校验`，其中奇偶校验位只是所有 8 个数据位的 XOR。  

**分析**  
奇偶校验是检验传输数据中1的个数。  
通过检验位将传输1的个数变成奇数就是奇校验，变成偶数就是偶校验。  
简单来说，数据位+校验位 异或结果为0是偶校验，结果为1是奇校验。  

**答案**  
```
module top_module (
    input [7:0] in,
    output parity); 
    
    assign parity = ^in;

endmodule
```

</details>

## 39 Reduction - Even wider gates
<details>
<summary>详情</summary>

在 [99:0] 中构建一个具有 100 个输入的组合电路。  
有3个输出：
- out_and：100 输入与门的输出。
- out_or：100 输入或门的输出。
- out_xor：100 输入异或门的输出。

**分析**  
无。

**答案**  
```
module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);
    assign out_and = & in;
    assign out_or = | in;
    assign out_xor = ^ in;

endmodule
```

</details>

## 40 Combinational for-loop - Vector reversal 2
<details>
<summary>详情</summary>

给定一个 100 位输入向量 [99:0]，反转其位顺序。  

**分析**  
循环语句。。。

**答案**  
```
module top_module( 
    input [99:0] in,
    output [99:0] out
);
    int i;
    always @(*) begin 
        for (i = 0; i < 100; i = i + 1)
        	out[i] = in[99 - i];
    end 

endmodule
```

</details>

## 41 Combinational for-loop - 255-bit population count
<details>
<summary>详情</summary>

population count电路计算输入向量中“1”的数量。为 255 位输入向量构建population count电路。  

**分析**  
还是循环。 

**答案**  
```
module top_module( 
    input [254:0] in,
    output [7:0] out );
    int i;
    always @(*) begin 
        out = 0;
        for (i = 0; i < 255; i = i + 1)
            if (in[i] == 1) begin
                out = out + 1'b1;
            end
    end 

endmodule
```

</details>

## 42 Generate for-loop - 100-bit binary adder 2
<details>
<summary>详情</summary>

通过实例化 100 个全加器来创建一个 100 位二进制进位加法器。
该加法器有两个100bit的输入和cin，输出为sum与cout。
为了鼓励您实际实例化全加器，还要输出每个全加器的cout。
cout[99] 是最后一个全加器的最终进位，也是您通常看到的进位。  

**分析**  
对于每一个sum和cout来说，均符合：  
`{cout,sum} = a + b + cout`  
想法2：  
`sum = a ^ b ^ cout`  
`cout = a & b | a & cout | b & cout`  

**答案**  
```
module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    
    int i;
    always @(*) begin
        for(i=0;i<100;i=i+1)begin
            {cout[i],sum[i]} = a[i] + b[i] + ((i == 0) ? cin : cout[i-1]);
        end
    end

endmodule
```

</details>

## 43 Generate for-loop - 100-digit BCD adder
<details>
<summary>详情</summary>

为您提供了一个名为 bcd_fadd 的 BCD 一位加法器，该加法器将两个 BCD 数字和cin相加，并产生一个sum和cout。  
```
module bcd_fadd (
    input [3:0] a,
    input [3:0] b,
    input     cin,
    output   cout,
    output [3:0] sum );
```
实例化 100 个 bcd_fadd 以创建一个 100 位 BCD 进位加法器。
您的加法器应将两个 100 位 BCD 数字（总共 400 位向量）和一个cin相加，以产生一个 100 位的sun和cout。  

**分析**  
实例化100个。。。不大好一个一个写出来了把。哈哈哈哈/狗头  
这里使用生成块`generate`语句。

**答案**  
```
module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    
    wire [99:0] coutm;
    bcd_fadd bcd_fadd_0 (a[3:0], b[3:0], cin, coutm[0], sum[3:0]);
    
    genvar i;
    generate for (i = 1; i < 100; i = i + 1)
    begin: Bcdadd100
        bcd_fadd bcd_fadd_i (a[4*i+3:4*i], b[4*i+3:4*i], coutm[i - 1], coutm[i], sum[4*i+3:4*i]);
    end
    endgenerate
    
    assign cout = coutm[99];

endmodule
```

</details>

