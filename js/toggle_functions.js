
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

    if(icon.classList[1].includes('plus') || icon.classList[1].includes('minus')){
        icon.classList.toggle("fa-plus");
        icon.classList.toggle("fa-minus");
    }
    if(icon.classList[1].includes('caret')){
        icon.classList.toggle("fa-caret-down");
        icon.classList.toggle("fa-caret-right");
    }
    if(icon.classList[1].includes('angle')){
        icon.classList.toggle("fa-angle-down");
        icon.classList.toggle("fa-angle-right");
    }
}


