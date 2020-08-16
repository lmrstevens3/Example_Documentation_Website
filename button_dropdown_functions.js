function createLinkedButton(buttonClassName, label, link) {
    const button = document.createElement("button");
    const buttonLink = document.createElement("a");

    button.className = buttonClassName;
    buttonLink.href = link;
    buttonLink.target = "_blank";
    buttonLink.innerHTML = label;

    button.appendChild(buttonLink)
    return(button)
}

function createDropdown(dropdownBtnClassName, label, dropdownMenu) {
    const dropdownDiv = document.createElement("div");
    const button = document.createElement("button");
    const caret = document.createElement("span");
    const menu = createLinkList(dropdownMenu, "dropdown-menu");

    dropdownDiv.className = "dropdown";
    dropdownDiv.style.display = "inline-block";

    button.className = dropdownBtnClassName;
    button.type = "button";
    button.setAttribute("data-toggle", "dropdown");
    caret.className = "fa fa-caret-down";
    button.innerHTML= label;

    button.appendChild(caret);
    dropdownDiv.appendChild(button);
    dropdownDiv.appendChild(menu);
    return(dropdownDiv)
}

function createLinkList(links, listClassName) {
    const list = document.createElement("ul")
    list.className = listClassName;
    links.forEach(function (a) {
        const listItem = document.createElement("li");
        const link = document.createElement("a");
        link.href = a.link;
        link.innerHTML = a.label;
        link.target = a.target;
        listItem.appendChild(link);
        list.appendChild(listItem);
    })
    return(list)
}

function createButton(btnContent){
    let btn;
    if(btnContent.btntype === "link") {
        btn = createLinkedButton(btnContent.className, btnContent.label, btnContent.link);
    }
    if(btnContent.btntype === "dropdown") {
        btn = createDropdown(btnContent.className, btnContent.label, btnContent.menu);
    }
    return(btn)
}

function createButtons(btnsContent) {
    const btnDiv = document.createElement("div");
    btnDiv.style.marginTop = "1%";
    btnDiv.style.marginBottom = "1%";

    btnsContent.forEach(btnContent => {
        const item = document.createElement("span");
        item.style.type = 'button';
        item.style.padding = "0.5rem";
        const btn = createButton(btnContent);
        btnDiv.append(item);
        item.append(btn);
    })
    return(btnDiv);
}