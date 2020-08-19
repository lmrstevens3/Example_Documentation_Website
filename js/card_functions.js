// Create Cards for Home Page and Dataset Resources
function createCardContent(cardContent) {
    const content = document.createElement("div");
    const header = document.createElement("h3");
    const cardButtonsDiv = createButtons(cardContent["btnContent"]);

    content.className = cardContent.contentClassName;

    if (typeof cardContent.icon !== 'undefined') {
        const icon = document.createElement("i");
        icon.className = cardContent.icon;
        content.appendChild(icon);
    }

    header.innerHTML = cardContent.header;
    content.appendChild(header)

    if (typeof cardContent.content !== 'undefined') {
        const text = document.createElement("p");
        text.innerHTML = cardContent.content;
        content.appendChild(text);
    }


    content.appendChild(cardButtonsDiv);
    return(content)
}
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
function createCards(cardsContent, parentElement, cardContainerClassName) {
    Object.values(cardsContent).forEach(cardContent => {
        const cardContainer = document.createElement("div");
        cardContainer.className = cardContainerClassName;
        const card = createCard(cardContent)

        parentElement.appendChild(cardContainer);
        cardContainer.appendChild(card);

    })
}

function createRowDiv(rowClass){
    const rowDiv=  document.createElement("div");
    rowDiv.className = rowClass;
    return(rowDiv)
}