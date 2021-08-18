function createCollapsibleButton(collapsibleBtnContent, btnClassName = "collapsible", idCollapsibleContent) {
    const btn = document.createElement("button");
    btn.className = "collapsible";
    if (typeof collapsibleBtnContent.anchor !== 'undefined') {
        anchor = createAnchor(collapsibleBtnContent['anchorContent']);
        btn.appendChild(anchor)
    }


    const innerContent = document.createElement("span");
    const header = document.createElement("h2");
    const img = document.createElement("img");

    const plusIcon = document.createElement("i");

    const questionsContent = document.createElement("div");







    plusIcon.className = "fas fa-plus";
    plusIcon.id = content_id + "-plus";
    categoryBtn.onclick = function() {toggle(content_id, plusIcon.id)};

    questionsContent.className = "collapsible-content";
    questionsContent.id = content_id;
    questionsContent.style.display = "block";
}

function createAnchor(anchorContent) {
    const anchor = document.createElement("a");
    anchor.id = anchorContent.id;
    if (typeof className !== 'undefined') {
        anchor.className = anchorContent.id;
    }
    return(anchor)
}



function createLinkedButton(buttonClassName, label, link, onclick = null, target) {
    const button = document.createElement("button");
    const buttonLink = document.createElement("a");

    button.className = buttonClassName;
    buttonLink.href = link;
    buttonLink.target = target;
    buttonLink.setAttribute('onclick', onclick)
    buttonLink.innerHTML = label;
    button.appendChild(buttonLink)
    return(button)
}

function createDropdown(dropdownBtnClassName, label, dropdownMenu) {
    const dropdownDiv = document.createElement("div");
    const button = document.createElement("button");
    const caret = document.createElement("i");
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
        link.target = a.target;
        link.innerHTML = a.label;
        link.onclick = a.onclick;
        listItem.appendChild(link);
        list.appendChild(listItem);
    })
    return(list)
}

function createButton(btnContent){
    let btn;
    if(btnContent.btntype === "link") {
        btnContent.target = (typeof btnContent.target !== 'undefined') ?  btnContent.target : "_blank"
        btn = createLinkedButton(btnContent.className, btnContent.label, btnContent.link, btnContent.onclick, btnContent.target);
    }
    if(btnContent.btntype === "dropdown") {
        btn = createDropdown(btnContent.className, btnContent.label, btnContent.menu);
    }
    return(btn)
}

function createButtons(btnsContent) {
    const btnDiv = document.createElement("div");
    btnsContent.forEach(btnContent => {
        const item = document.createElement("div");
        item.className= "btns-menu";
        const btn = createButton(btnContent);
        btnDiv.append(item);
        item.append(btn);
    })
    return(btnDiv);
}
