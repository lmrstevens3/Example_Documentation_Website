// Create Cards for Home Page and Dataset Resources
function createCardContent(cardContent) {
    const content = document.createElement("div");
    if (typeof cardContent.contentClassName !== 'undefined') {
        content.className = cardContent.contentClassName;
    }

    if (typeof cardContent.icon !== 'undefined') {
        const icon = document.createElement("i");
        icon.className = cardContent.icon;
        content.appendChild(icon);
    }

    if (typeof cardContent.header !== 'undefined') {
        const header = document.createElement("h3");
        header.innerHTML = cardContent.header;
        content.appendChild(header)
    }

    if (typeof cardContent.content !== 'undefined') {
        content.insertAdjacentHTML("beforeend", cardContent.content);
    }

    if (typeof cardContent.btnContent !== 'undefined') {
        const cardButtonsDiv = createButtons(cardContent["btnContent"]);
        content.appendChild(cardButtonsDiv);
    }

    if (typeof cardContent.link !== 'undefined') {
        content.onclick = function() {
            window.location.href = cardContent.link;
        };
    }
    if (typeof cardContent.message !== 'undefined') {
        content.insertAdjacentHTML("beforeend", cardContent.message);
    }

    return(content)
}



// Create Cards for Docs Home Page, Dataset Resource Home, and Dataset Resources
// functions to create card from json object
// cardClassName is the class for the card
function createCard(cardContent) {
    const card = document.createElement("div");
    const content = createCardContent(cardContent);


    card.className = cardContent.cardClassName;
    card.appendChild(content);

    return(card)
}

// function to create rows of cards from json object
// parentElement is variable of parent element the card should be appended to
function createCards(cardsContent, parentElement, cardContainerClassName= null) {
    Object.values(cardsContent).forEach(cardContent => {
        const card = createCard(cardContent)
        if (cardContainerClassName === null) {
            parentElement.appendChild(card);
        } else {
            const cardContainer = document.createElement("div");
            cardContainer.className = cardContainerClassName;
            cardContainer.appendChild(card);
            parentElement.appendChild(cardContainer);
        }
    })
}



function createRowDiv(rowClass){
    const rowDiv = document.createElement("div");
    rowDiv.className = rowClass;
    return(rowDiv)
}
