
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
    toggle(id, leave_open);
    toggle_content(sub_id, sub_icon_id);
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

// function toggle_caret(id, caret_id) {
//     toggle_content(id);
//     const caret = document.getElementById(caret_id);
//     caret.classList.toggle("fa-caret-down");
//     caret.classList.toggle("fa-caret-right");
// }
//
// function toggle_plus(id, plus_id) {
//     toggle_content(id);
//     const icon = document.getElementById(plus_id);
//     icon.classList.toggle("fa-plus");
//     icon.classList.toggle("fa-minus");
// }
//
// function toggle_angle(id, angle_id) {
//     toggle_content(id);
//     const icon = document.getElementById(angle_id);
//     icon.classList.toggle("fa-angle-down");
//     icon.classList.toggle("fa-angle-right");
// }


// function collapse(id, icon, leave_open) {
//     const content = document.getElementById(id);
//     if (content.style.display !== "block" || leave_open) {
//         content.style.display = "block";
//     } else {
//         content.style.display = "none";
//
//     }
// }

// function collapse_sub(id, leave_open, sub_id) {
//     collapse(id, leave_open);
//     collapse(sub_id);
// }

