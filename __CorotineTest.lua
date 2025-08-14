-- function foo()
--     print("Corotine foo start processing.")
--     local value = coroutine.yield("pausing foo processing.")
--     print("Corotine foo resume, and get a value: " .. tostring(value))
--     print("Corotine foo process end.")
-- end

-- -- 创建协同程序
-- local co = coroutine.create(foo)

-- -- 启动协同程序
-- local status, result = coroutine.resume(co)
-- print(result) -- 输出: 暂停 foo 的执行

-- -- 恢复协同程序的执行，并传入一个值
-- status, result = coroutine.resume(co) -- 这里的传参方式很奇怪
-- print(result) -- 输出: 协同程序 foo 恢复执行，传入的值为: 42


do  
    function foo(...)  
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...); -->读取参数，arg 对应的是右边变量列表的第一个参数
            print("arg", arg);  
        end  
    end  
 
    foo(1, 2, 3, 4);  
end