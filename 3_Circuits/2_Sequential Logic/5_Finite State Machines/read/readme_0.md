# Circuits -> Sequential Logic -> Finite State Machines

## 0 写在前面
- [119-127](./readme_0.md)
- [128-134](./readme_1.md)
- [135-141](./readme_2.md)
- [142-151](./readme_3.md)

## 119 Simple FSM 1 - asynchronous reset
<details>
<summary>详情</summary>

这是一个具有两种状态的摩尔状态机，一种输入和一种输出。实现这个状态机。请注意，重置状态为 B。  
本题为异步复位。  
![](./images/0.jpg)  

**分析**  
状态机弄明白有哪些状态。  
本题中，复位状态，下一状态，当前状态。注意下状态跳转条件即可。  

**答案**  
```
module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        if (areset) state <= B;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == B);

endmodule

```

</details>

## 120 Simple FSM 1 - synchronous reset
<details>
<summary>详情</summary>

与119类似，区别仅为同步复位。  
![](./images/1.jpg)   

**分析**  
无。  

**答案**  
```
module top_module(
    input clk,
    input reset,    // Asynchronous reset to state B
    input in,
    output out);//

    parameter A=0, B=1;
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end

    always @(posedge clk) begin    // This is a sequential always block
        if (reset) state <= B;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == B);

endmodule
```

</details>

## 121 Simple FSM 2 - asynchronous reset
<details>
<summary>详情</summary>

与119类似，仅调整`跳转状态条件`。异步复位。  

状态跳转如下图所示。  
![](./images/2.jpg)  

**分析**  
无。

**答案**  
```
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON: next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if (areset) state <= OFF;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule

```

</details>

## 122 Simple FSM 2 - synchronous reset
<details>
<summary>详情</summary>

与120类似，仅调整`跳转状态条件`。同步复位。  

状态跳转如下图所示。  
![](./images/3.jpg)  

**分析**  
无。

**答案**  
```
module top_module(
    input clk,
    input reset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON: next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= OFF;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule

```

</details>

## 123 Simple state transitions 3
<details>
<summary>详情</summary>

构建一输入一输出四状态的摩尔状态机。  
`A=2'b00, B=2'b01, C=2'b10, D=2'b11`。  
以下是状态转移表。   
![](./images/4.jpg)  

**分析**  
注意，程序内部状态不进行跳转。。。

**答案**  
```
module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=2'b0, B=2'b01, C=2'b10, D=2'b11;
    always @(*)begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;  
        endcase
    end
    assign out = (state==D);

endmodule

```

</details>

## 124 Simple one-hot state transitions 3
<details>
<summary>详情</summary>

构建一输入一输出四状态的摩尔状态机。  
`A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000`。  
以下是状态转移表。   
![](./images/4.jpg)  

**分析**  
与123一样。  
不太一样...博主一开始和123的写法相同，但是错误的输入state题中没有给出对应的处理措施，因此需要更换方法。
（其实我觉得我的应该可行，对照网上其他的方法，我觉得out的值欠妥。。。）  
根据独热码的性质，输出仅有一位 置高，因此，只需要`判断next_state[i]何时置高`即可。  

**答案**  
```
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    assign next_state[A] = state[A] & ~in | state[C] & ~in;
    assign next_state[B] = state[A] & in | state[B] & in | state[D] & in;
    assign next_state[C] = state[B] & ~in | state[D] & ~in;
    assign next_state[D] = state[C] & in;
    assign out = state[D];

endmodule
```

</details>

## 125 Simple FSM 3 - asynchronous reset
<details>
<summary>详情</summary>

构建一输入一输出四状态的摩尔状态机。`异步复位，复位置A`。  
`A=2'b00, B=2'b01, C=2'b10, D=2'b11`。  
以下是状态转移表。   
![](./images/4.jpg)  

**分析**  
与123一样。  
内部发生状态转移。  

**答案**  
```
module top_module(
    input clk,
    input in,
    input areset,
    output out); //

    parameter A=2'b0, B=2'b01, C=2'b10, D=2'b11;
    reg [1:0] next_state,state;
    always @(*)begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end
    
    always @(posedge clk or posedge areset)begin
        if (areset) state <= A;
        else state <= next_state;
    end
    
    assign out = (state==D);
endmodule
```

</details>

## 126 Simple FSM 3 - synchronous reset
<details>
<summary>详情</summary>

构建一输入一输出四状态的摩尔状态机。`同步复位，复位置A`。  
`A=2'b00, B=2'b01, C=2'b10, D=2'b11`。  
以下是状态转移表。   
![](./images/4.jpg)  

**分析**  
与125一样。  

**答案**  
```
module top_module(
    input clk,
    input in,
    input reset,
    output out); //

    parameter A=2'b0, B=2'b01, C=2'b10, D=2'b11;
    reg [1:0] next_state,state;
    always @(*)begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end
    
    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end
    
    assign out = (state==D);
endmodule
```

</details>

## 127 Design a Moore FSM
<details>
<summary>详情</summary>

无。   
![](./images/4.jpg)  

**分析**  
无。  

**答案**  
```
无
```

</details>
