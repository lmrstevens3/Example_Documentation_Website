const hidden_width = "3rem";
const visible_width = "16rem";
const transition = 400;
const footer_back_color = "#e9ecef";

function sidebar_toggle() {
    const sbc = document.getElementById("sidebar_content");
    const sidebar = document.getElementById("collapsible_sidebar");
    const main = document.getElementById("main");
    const footer = document.getElementById("footer-container");

    sidebar.style.transition = transition + "ms";
    if (sidebar.isClosed) {
        main.style.marginLeft = visible_width;
        sidebar.style.width = visible_width;
        setTimeout(function () { sbc.style.display = ""}, transition);
        sidebar.isClosed = false;
        footer.style.paddingLeft = visible_width;
        footer.style.backgroundColor = footer_back_color;
    } else {
        main.style.marginLeft = hidden_width;
        sidebar.style.width = hidden_width;
        footer.style.paddingLeft = "0";

        sbc.style.display = "none";
        sidebar.isClosed = true;
    }
}

function adjust_footer() {
    const footer = document.getElementById("footer-container");
    footer.style.paddingLeft = visible_width;
    footer.style.backgroundColor = footer_back_color;
}

function adjustSideBar() {
    const sidebar = document.getElementById("collapsible_sidebar");
    const titleHeight = document.getElementsByClassName("aha_pmp_header").clientHeight;
    const buttonHeight = document.getElementById("sidebarToggleButton").clientHeight;
    const footerInView = document.getElementById("footer-container").getBoundingClientRect();

    sidebar.style.height = "calc(100% -  " +
    (Math.max(window.innerHeight - footerInView.top, 0) + buttonHeight + titleHeight) + "px)"
}
