
function toggle_content(id, leave_open) {
    const content = document.getElementById(id);
    // cont.style.display = (cont.style.display !== 'none' ? 'none' : 'block');
    if (content.style.display !== "block" || leave_open) {
        content.style.display = "block";
    } else {
        content.style.display = "none";

    }
}

function toggle_sub(id, icon_id, leave_open, sub_id,  sub_icon_id) {
    toggle_content(id, leave_open);
    toggle(sub_id, sub_icon_id, leave_open);
}

function toggle(id, icon_id, leave_open) {
    toggle_content(id, leave_open);

    let icon = document.getElementById(icon_id);
    let icon_class = icon.classList[1];
    let toggle_class;

    if(icon_class.includes('down') ){
        toggle_class = icon_class.replace("down", "right");
    }
    if(icon_class.includes('right')) {
        toggle_class = icon_class.replace("right", "down");
    }
    if(icon_class.includes('minus')){
        toggle_class = icon_class.replace("minus", "plus");
    }
    if(icon_class.includes('plus')){
        toggle_class = icon_class.replace("plus", "minus");
    }
    icon.classList.toggle(toggle_class, icon_class);
    icon.classList.toggle(icon_class);
}


