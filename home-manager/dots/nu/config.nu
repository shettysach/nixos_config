$env.config = {
    table.mode: "single"
    show_banner: false
    edit_mode: "vi"
    cursor_shape: {vi_insert: "line", vi_normal: "block"}
    completions: {
        algorithm: "prefix"
        sort: "smart"
        quick: true
        partial: true
    }
    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: ""
            type: {layout: columnar, columns: 1}
            style: {text: white, selected_text: cyan_reverse, description_text: blue}
        }
        {
            name: history_menu
            only_buffer_difference: false
            marker: ""
            type: {layout: list, page_size: 10}
            style: {text: white, selected_text: cyan_reverse, description_text: blue}
        }
    ]
}
$env.VIRTUAL_ENV_DISABLE_PROMPT = true
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "  "
