古文

![screenshot](https://user-images.githubusercontent.com/6236829/200225797-0f148206-8d28-47f2-915d-bf23ac7b7cff.jpg)

## 使用环境
* linux
* nvim 0.11.*
* haolian9/infra.nvim

## 使用
* 用户按需调用 `math.randomseed` 
* `:lua require'guwen'.唐诗一首()`，`nnoremap <buf> gn` 随机下一个
* 我个人设置
```
do --:Guwen
  local comp = cmds.ArgComp.constant(function() return require("guwen").comp.available_sources() end)

  local spell = cmds.Spell("Guwen", function(args) require("guwen")[args.op]() end)
  spell:add_arg("op", "string", true, nil, comp)
  cmds.cast(spell)
end
```

## 鸣谢
* 数据源: https://github.com/chinese-poetry/chinese-poetry
