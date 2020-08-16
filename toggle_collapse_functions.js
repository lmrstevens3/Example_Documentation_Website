




function toggle_content(id) {
    const cont = document.getElementById(id);
    cont.style.display = (cont.style.display !== 'none' ? 'none' : '');
}

function toggle_caret(id, x) {
    toggle_content(id);
    x.classList.toggle("fa-angle-down");
    x.classList.toggle("fa-angle-right");
}

function toggle_angle(id, x) {
    toggle_content(id);
    x.classList.toggle("fa-angle-down");
    x.classList.toggle("fa-angle-right");
}

function collapse(id, leave_open) {

    const content = document.getElementById(id);
    if (content.style.display !== "block" || leave_open) {
        content.style.display = "block";
    } else {
        content.style.display = "none";

    }
}

function collapse_sub(id, leave_open, sub_id) {
    collapse(id, leave_open);
    collapse(sub_id);
}

