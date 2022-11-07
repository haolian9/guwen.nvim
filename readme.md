## 古文

![screenshot](https://user-images.githubusercontent.com/6236829/200225797-0f148206-8d28-47f2-915d-bf23ac7b7cff.jpg)

## 使用环境
* linux
* nvim 0.8.0

## 设置
```lua
require("guwen.setup")({
  -- optional: 自定义 hi group
  NormalFloat = { ctermfg = 8 },
  FloatBorder = { ctermfg = 240 },
})
```

## 使用
```lua
-- 通过 lua api
lua require'guwen'.唐诗一首()

-- 通过用户命令
api.nvim_create_user_command("Guwen", function(args)
  require("guwen")[args.args]()
end, {
  nargs = 1,
  complete = function()
    return require'guwen'._completion
  end,
})
```

## 待办、想法
* ~~增加适当的样式: 比如正文使用隶书、魏碑~~ 受限于 TUI，插件层面无能为力
* ~~阅读历史~~
* ~~阅读偏好~~
* [x] 在 window 开启 &wrap 时恰当设置其 height
* ~~提前对数据源切分，减小加载开销~~
* ~~自定义显示内容、格式~~ 涉及到居中、floatwin 高度设置，颇为复杂
* 增加测试 (这可咋加啊)
* 提供某种反馈机制把用户校对贡献到上游数据源（翻看 chinese-poetry 的 issue 页面有感）
* 提供选项将窗口钉到右上角
* 提供查释义、读音功能，哈哈

## 鸣谢
* 数据源: https://github.com/chinese-poetry/chinese-poetry
