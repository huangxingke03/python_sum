import toga
from toga.constants import COLUMN
from toga.style import Pack
from datetime import datetime


def build(app):
    # 主容器：垂直布局，居中对齐
    main_box = toga.Box(style=Pack(direction=COLUMN, padding=20, alignment="center"))

    # 标题
    title = toga.Label(
        "欢迎使用问候 App！",
        style=Pack(font_size=28, padding=(0, 0, 20, 0), text_align="center"),
    )

    # 输入框
    name_input = toga.TextInput(
        placeholder="请输入你的名字", style=Pack(padding=10, width=350, font_size=16)
    )

    # 输出结果（动态更新）
    result_label = toga.Label(
        "", style=Pack(padding=15, font_size=20, color="#007BFF", text_align="center")
    )

    # 语言切换按钮（中/英）
    current_lang = "zh"  # 默认中文
    lang_button = toga.Button(
        "切换到 English",
        style=Pack(padding=10, background_color="#FFC107", color="black"),
    )

    def switch_language(widget):
        nonlocal current_lang
        if current_lang == "zh":
            current_lang = "en"
            lang_button.text = "切换到 中文"
            title.text = "Welcome to Greet App!"
            name_input.placeholder = "Enter your name"
        else:
            current_lang = "zh"
            lang_button.text = "切换到 English"
            title.text = "欢迎使用问候 App！"
            name_input.placeholder = "请输入你的名字"

    lang_button.on_press = switch_language

    # 问候按钮
    def greet(widget):
        name = name_input.value.strip()
        if not name:
            result_label.text = (
                "请输入名字哦～" if current_lang == "zh" else "Please enter your name~"
            )
            result_label.style.color = "#dc3545"  # 红色
            return

        now = datetime.now().strftime(
            "%Y年%m月%d日 %H:%M:%S" if current_lang == "zh" else "%Y-%m-%d %H:%M:%S"
        )
        greeting = (
            f"你好，{name}！现在是 {now}。"
            if current_lang == "zh"
            else f"Hello, {name}! It's {now} now."
        )
        result_label.text = greeting
        result_label.style.color = "#28a745"  # 绿色

    greet_button = toga.Button(
        "问候我",
        on_press=greet,
        style=Pack(padding=10, background_color="#28a745", color="white", font_size=16),
    )

    # 组装界面
    main_box.add(title)
    main_box.add(name_input)
    main_box.add(greet_button)
    main_box.add(lang_button)
    main_box.add(result_label)

    # 返回主窗口
    return main_box


def main():
    return toga.App("Greet App", "com.example.greetapp", startup=build)


if __name__ == "__main__":
    main().main_loop()
