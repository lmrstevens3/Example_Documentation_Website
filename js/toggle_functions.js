
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
    toggle(sub_id, sub_icon_id);
}

function toggle(id, icon_id, leave_open) {
    toggle_content(id, leave_open);
    const icon = document.getElementById(icon_id);
    let toggle_class;

    // if(icon.classList[1].includes('plus') || icon.classList[1].includes('minus')){
    //     icon.classList.toggle("fa-plus");
    //     icon.classList.toggle("fa-minus");
    // }
    if(icon.classList[1].includes('down')){
        toggle_class = str.replace("down", "right");

        // icon.classList.toggle("fa-caret-down");
        // icon.classList.toggle("fa-caret-right");
    }
    if(icon.classList[1].includes('right')) {
        toggle_class = str.replace("right", "down");
    }
    if(icon.classList[1].includes('minus')){
        toggle_class = str.replace("minus", "plus");
    }
    if(icon.classList[1].includes('plus')){
        toggle_class = str.replace("plus", "minus");
    }
    icon.classList.toggle(toggle_class);
    // if(icon.classList[1].includes('angle-double')){
    //     icon.classList.toggle("fa-angle-double-down");
    //     icon.classList.toggle("fa-angle-right");
    // }
    // if(icon.classList[1].includes('angle')){
    //     icon.classList.toggle("fa-angle-down");
    //     icon.classList.toggle("fa-angle-right");
    // }
}


