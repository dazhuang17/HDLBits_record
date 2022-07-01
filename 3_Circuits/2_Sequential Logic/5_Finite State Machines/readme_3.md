# Circuits -> Sequential Logic -> Finite State Machines

## -1 写在前面
- [119-127](./readme_0.md)
- [128-134](./readme_1.md)
- [135-141](./readme_2.md)
- [142-151](./readme_3.md)

## 142 Q3a:FSM
<details>
<summary>详情</summary>

考虑一个具有输入 s 和 w 的有限状态机。假设 FSM 以称为 A 的复位状态开始，如下图所示。
只要 s = 0，FSM 就保持在状态 A，当 s = 1 时，它移动到状态 B。
一旦处于状态 B，FSM 在接下来的三个时钟周期内检查输入 w 的值。
三个时钟周期中，w被置高两次，则 FSM 必须在下一个时钟周期中将输出 z 设置为 1。否则 z 必须为 0。
FSM 在接下来的三个时钟周期内继续检查 w，依此类推。下面的时序图说明了不同 w 值所需的 z 值。  

使用尽可能少的状态。请注意，s 输入仅在状态 A 中使用，因此您只需考虑 w 输入。  
![](./images/18.jpg)  

**分析**  
锁存器存储w前两个值，前两个值与第三个值进行比较。  
注意时序。  
博主非常建议画一画时序图以及当前时序下的变量的当前值与非阻塞值。  

**答案**  
```
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=1'b0,
              B=1'b1;
    reg state,next_state;
    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B : next_state = B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end
    
    reg [1:0] temp;
    reg [1:0] cnt=2'b0;
    reg flag;
    always @(posedge clk)begin
        if (reset) begin 
            flag <= 1'b0;
            cnt <= 3'b0;
        end
        else if (state==B) begin 
            //flag <= 1'b1;
            if (cnt==3'd2)begin 
                cnt <= 3'b0;
                if (temp[1]+temp[0]+w == 2'd2) begin 
                //if(~(^temp ^ w))begin
                    flag <= 1'b1;
                    //temp <= 2'b0;
                end
                else flag <= 1'b0;
            end
            else begin
                temp <= {temp[0],w};
                cnt <= cnt + 1'b1;
                flag <= 1'b0;
            end
        end
    end
    
    assign z = flag;

endmodule
```

</details>

## 143 Q3b:FSM
<details>
<summary>详情</summary>

给定如下所示的状态分配表，实现有限状态机。重置应该将 FSM 重置为状态 000。  

![](./images/19.jpg)   

**分析**  
看图说话。  

**答案**  
```
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    parameter A = 3'b000, 
  			  B = 3'b001, 
  			  C = 3'b010, 
  			  D = 3'b011, 
  			  E = 3'b100;
    
    reg [2:0] state,next_state;
    
    always @(*) begin
        case(state)
            A: next_state = x ? B : A;
            B: next_state = x ? E : B;
            C: next_state = x ? B : C;
            D: next_state = x ? C : B;
            E: next_state = x ? E : D;
            default: next_state = A;
        endcase
    end
    
    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end
    
    assign z = (state==D | state==E);

endmodule
```

</details>

## 144 Q3c:FSM logic
<details>
<summary>详情</summary>

给定如下所示的状态分配表，实现逻辑函数 Y[0] 和 z。  

![](./images/19.jpg)  

**分析**  
将143的state用输入y取代。

**答案**  
```
module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    parameter A = 3'b000,
  			  B = 3'b001,
  			  C = 3'b010,
  			  D = 3'b011,
  			  E = 3'b100;

    reg [2:0] state,next_state;

    always @(*) begin
        case(y)
            A: next_state = x ? B : A;
            B: next_state = x ? E : B;
            C: next_state = x ? B : C;
            D: next_state = x ? C : B;
            E: next_state = x ? E : D;
            default: next_state = A;
        endcase
    end
	
    /*
    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end
    */

    assign z = (y==D | y==E);
    assign Y0 = next_state[0];

endmodule
```

</details>

## 145 Q6b:FSM next-stage logic
<details>
<summary>详情</summary>

考虑如下所示的状态机，它有一个输入 w 和一个输出 z。  

![](./images/20.jpg)  

假设您希望使用三个触发器和状态代码 y[3:1] = 000, 001, ..., 101 分别用于状态 A、B、...、F 来实现 FSM。
显示此 FSM 的状态分配表。导出触发器 y[2] 的下一个状态表达式。

只为 y[2] 实现下一个状态逻辑。 （这更像是一个 FSM 问题，而不是 Verilog 编码问题。哦，好吧。）

**分析**  
写状态机就完事了。  
`也可以直接写出next_state[2]和什么有关。`

**答案**  
```
module top_module (
    input [3:1] y,
    input w,
    output Y2);
    parameter A = 3'b000, B = 3'b001, C = 3'b010,
         	  D = 3'b011, E = 3'b100, F = 3'b101;
    reg [3:1] state,next_state;
    
    always @(*) begin
        case(y)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end
    
    assign Y2 = next_state[2];

endmodule
```

</details>

## 146 Q6c:FSM one-hot next-stage logic
<details>
<summary>详情</summary>

考虑如下所示的状态机，它有一个输入 w 和一个输出 z。  

![](./images/20.jpg)  
对于这一部分，假设状态分配 'y[6:1] = 000001, 000010, 000100, 001000, 010000, 100000 分别用于状态 A、B、...、F 的 one-hot 代码。

为下一状态信号 Y2 和 Y4 编写逻辑表达式。 （通过假设 one-hot 编码的检查推导出逻辑方程。测试台将使用非 one hot 输入进行测试，以确保您不会尝试做更复杂的事情）。

**分析**  
因何而产生Y2、Y4即可。  

**答案**  
```
module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);
    
    assign Y2 = y[1] & (~w);
    assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule
```

</details>

## 147 Q6:FSM
<details>
<summary>详情</summary>

考虑如下所示的状态机，它有一个输入 w 和一个输出 z。   
![](./images/20.jpg)  

**分析**  
与145没什么区别。   

**答案**  
```
module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    
    parameter A = 3'b000, B = 3'b001, C = 3'b010,
         	  D = 3'b011, E = 3'b100, F = 3'b101;
    reg [3:1] state,next_state;

    always @(*) begin
        case(state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end
    
    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end

    assign z = (state==E | state==F);

endmodule
```

</details>

## 148 Q2a:FSM
<details>
<summary>详情</summary>

编写代表此 FSM 的完整 Verilog 代码。对状态表和状态触发器使用单独的 always 块。
使用连续赋值语句或 always 块（由您自行决定）描述 FSM 输出，称为 z。分配您希望使用的任何州代码。   
![](./images/21.jpg)  

**分析**  
哈哈哈哈，他把图改了。  

**答案**  
```
module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);

    parameter A = 3'b000, B = 3'b001, C = 3'b010,
         	  D = 3'b011, E = 3'b100, F = 3'b101;
    reg [3:1] state,next_state;

    always @(*) begin
        case(state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end

    assign z = (state==E | state==F);

endmodule
```

</details>

## 149 One-hot FSM equations
<details>
<summary>详情</summary>

假设在状态分配 y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F) 中使用 one-hot 代码。
为信号 Y1 写一个逻辑表达式，它是状态触发器 y[1] 的输入。  
为信号 Y3 写一个逻辑表达式，它是状态触发器 y[3] 的输入。  
（通过假设 one-hot 编码的检查推导出逻辑方程。测试台将使用非 one hot 输入进行测试，以确保您不会尝试做更复杂的事情）。   

![](./images/21.jpg)  

**分析**  
写就完事了。  

**答案**  
```
module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    assign Y1 = w & y[0];
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule
```

</details>

## 150 Q2a:FSM
<details>
<summary>详情</summary>

完成以下状态转移。   

![](./images/22.jpg)  

**分析**  
没什么东西，写就完事了。  

**答案**  
```
无
```

</details>

## 151 Q2b: Another FSM
<details>
<summary>详情</summary>

考虑一个用于控制某种电机的有限状态机。 
FSM 有来自电机的输入 x 和 y，并产生控制电机的输出 f 和 g。
还有一个称为 clk 的时钟输入和一个称为 resetn 的复位输入。  

FSM 必须按如下方式工作。只要复位输入有效，FSM 就保持在开始状态，称为状态 A。
当复位信号无效时，在下一个时钟沿之后，FSM 必须在一个时钟周期内将输出 f 设置为 1 。
然后，FSM 必须监控 x 输入。当 x 在三个连续的时钟周期中产生值 1、0、1 时，应在下一个时钟周期将 g 设置为 1。
在保持 g = 1 的同时，FSM 必须监控 y 输入。如果 y 在最多两个时钟周期内为 1，则 FSM 应永久保持 g = 1（即，直到复位）。
但如果 y 在两个时钟周期内未变为 1，则 FSM 应永久设置 g = 0（直到复位）。  

**分析**  
注意一下复位和f的时序即可。  

**答案**  
```
module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    parameter A = 0,
              B = 1,
              C = 2,
              D = 3,
              E = 4,
              F = 5,
              G = 6,
              LOW = 7,
              HIGH = 8;
    
    reg [3:0] state, next_state;

    always @(*)
        case (state)
            A: next_state = B;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? D : E;
            E: next_state = x ? F : C;
            F: next_state = y ? HIGH : G;
            G: next_state = y ? HIGH : LOW;
            LOW: next_state = LOW;
            HIGH: next_state = HIGH;
            default: next_state = A;
        endcase
    
    always @(posedge clk) begin 
        if (~resetn) state <= A;
        else state <= next_state;
    end
    
    assign f = (state == B);
    assign g = (state == F | state == G | state == HIGH);

endmodule
```

</details>
