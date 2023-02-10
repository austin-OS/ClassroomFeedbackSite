// This file contains classes for handling the rendering of the interface
// for creating and modifying feedback forms
class FeedbackFormEditView {
    // Reference to FeedbackForm object containing data
    form;
    // List of view objects for rendering views for individual questions
    questionViews = [];
    // Reference to parent DOM object to render in
    parentElement;
    // References to commonly-accessed child elements
    questionContainer;
    submitButton;
    submitButtonContainer;
    validationMessageBox;

    // Constructor - stores references to form model object and parent
    // element, generates question views
    constructor(formObject, parentElement) {
        this.form = formObject;
        this.parentElement = parentElement;
        this.form.questions.forEach((question) => {
            this.questionViews.push(new FeedbackQuestionEditView(this, question, null));
        })
    }

    // Clear the parent element and render the view inside it
    render(parentElement=this.parentElement) {
        // Store parent element if different than current value
        this.parentElement = parentElement;

        // Set Bootstrap classes on parent elemetn for styling
        this.parentElement.className = "container";

        // Clear current contents
        this.parentElement.innerHTML = "";

        // Check if editing existing form or creating new one
        let isNewForm = (this.form.getID() == null);

        // Render header
        let header = this.parentElement.appendChild(document.createElement("h1"));
        header.textContent = (isNewForm ? "New Feedback Form" : "Edit Feedback Form");

        // Render input box for title
        let titleInputDiv = this.parentElement.appendChild(document.createElement("div"));
        let titleInputLabel = titleInputDiv.appendChild(document.createElement("label"));
        titleInputLabel.class = "form-label";
        titleInputLabel.textContent = "Form Title";
        let titleInput = titleInputDiv.appendChild(document.createElement("input"));
        titleInput.type = "text"
        titleInput.class = "form-control";
        titleInput.required = true;
        // Populate title input box and set it to update stored title on keydown
        titleInput.value = this.form.getTitle();
        titleInput.addEventListener("keyup", () => {
            this.form.setTitle(titleInput.value);
            this.validateInput();
        })

        this.parentElement.appendChild(document.createElement("hr"));

        // Render views for each individual question
        this.questionContainer = this.parentElement.appendChild(document.createElement("div"));
        //questionContainer.className = "questionContainer";
        this.questionViews.sort((a, b) => a.question.getOrder() - b.question.getOrder());
        this.questionViews.forEach((questionView) => {
            let individualQuestionContainer = this.questionContainer.appendChild(document.createElement("div"));
            questionView.render(individualQuestionContainer);
        });

        // Render button for creating new questions
        let newQuestionButton = this.parentElement.appendChild(document.createElement("button"));
        newQuestionButton.className = "btn btn-primary";
        newQuestionButton.textContent = "Add Question";
        newQuestionButton.addEventListener("click", () => {
            this.createQuestion();
        });
        this.parentElement.appendChild(document.createElement("hr"));

        // render submit button and back button
        this.submitButtonContainer = this.parentElement.appendChild(document.createElement("div"));
        this.validationMessageBox = this.submitButtonContainer.appendChild(document.createElement("div"));
        this.submitButton = this.submitButtonContainer.appendChild(document.createElement("button"));
        this.submitButton.className = "btn btn-success btn-large";
        this.submitButton.textContent = (isNewForm ? "Create" : "Save Changes")
        /* I was originally going to implement the validation messages through
        a tooltip but couldn't get it to work
        // when form content is invalid, submit button will be disabled and 
        // will have tooltip listing all current errors - this is handled by 
        // the container element since disabled buttons can't be interacted with
        this.submitButtonContainer.className = "d-inline-block";
        this.submitButtonContainer.setAttribute("data-bs-toggle", "tooltip");
        this.submitButtonContainer.setAttribute("data-bs-html", "true");
        new bootstrap.Tooltip(this.submitButtonContainer);
        */
        this.submitButton.addEventListener("click", () => {
            // store the form JSON in an invisible input element and POST
            // to feedback_forms#create route
            // code adapted from https://stackoverflow.com/a/43021899
            let submissionForm = document.createElement("form");
            submissionForm.style.visibility = "hidden";
            submissionForm.method = "POST";
            submissionForm.action = "/feedback_forms";
            let submissionInput = document.createElement("input");
            submissionInput.name = "form_details_json";
            submissionInput.value = JSON.stringify(this.form.formDetails);
            submissionForm.appendChild(submissionInput);
            this.parentElement.appendChild(submissionForm);
            submissionForm.submit();
        });
        this.validateInput();


        let backButton = this.parentElement.appendChild(document.createElement("a"));
        backButton.className = "btn btn-danger btn-large";
        backButton.textContent = "Cancel";
        backButton.href = "javascript:history.back()";
    }

    // Method for creating new question and also adding it to view
    createQuestion() {
        let newQuestion = this.form.createQuestion();
        this.questionViews.push(new FeedbackQuestionEditView(this, newQuestion, null));
        this.render();
    }

    // Method for deleting question and rerendering accordingly
    removeQuestion(questionView) {
        questionView.parentElement.remove();
        this.questionViews.splice(this.questionViews.indexOf(questionView), 1);
        this.form.removeQuestion(questionView.question);
        this.validateInput();
    }

    // Method for checking data validity and enabling or disabling 
    // submit button accordingly
    validateInput() {
        let errors = this.form.getModelErrors();
        // console.log(errors);
        if (errors.length == 0) {
            // clear tooltip and enable button
            // this.submitButtonContainer.setAttribute("data-bs-title", "");
            this.validationMessageBox.innerHTML = "";
            this.submitButton.disabled = false;
        } else {
            // disable button
            this.submitButton.disabled = true;
            // set validation message
            let tooltipText = "The following issues need to be corrected before the form can be saved:";
            tooltipText += "<ul>";
            errors.forEach((error) => {
                tooltipText += `<li>${error}</li>`;
            })
            tooltipText += "</ul>";
            this.validationMessageBox.innerHTML = tooltipText;
            // this.submitButtonContainer.setAttribute("data-bs-title", tooltipText);
        }
    }
}
class FeedbackQuestionEditView {
    // Reference to FeedbackQuestion object containing data
    question;
    // Reference to view object for form
    formView;
    // Reference to parent DOM object to render in
    parentElement;

    // Constructor - stores references to question model object, form
    // view object, and parent element.
    constructor(formView, questionObject, parentElement) {
        this.question = questionObject;
        this.formView = formView;
        this.parentElement = parentElement;
    }

    // Clear the parent element and render the view inside it
    render(parentElement=this.parentElement) {
        // Store specified parent element if different from current value
        this.parentElement = parentElement;

        // Set Bootstrap classes on parent element for styling
        // this.parentElement.className = "container";

        // Clear current contents
        this.parentElement.innerHTML = "";

        // Dropdown select for order
        let orderSelectorDiv = this.parentElement.appendChild(document.createElement("div"));
        let orderSelectorLabel = orderSelectorDiv.appendChild(document.createElement("label"));
        orderSelectorLabel.className = "form-label";
        orderSelectorLabel.textContent = "Question #";
        let orderSelector = orderSelectorDiv.appendChild(document.createElement("select"));
        orderSelector.className = "form-select";
        for (let i = 1; i <= this.formView.questionViews.length; ++i) {
            let orderOption = orderSelector.appendChild(document.createElement("option"));
            orderOption.value = i;
            orderOption.textContent = i;
            if (i == this.question.getOrder()) {
                orderOption.selected = true;
            }
        }
        orderSelector.addEventListener("change", () => {
            // update question order and rerender list
            let newOrderNum = orderSelector.options[orderSelector.selectedIndex].value;
            if (newOrderNum != this.question.getOrder()) {
                this.question.setOrder(newOrderNum);
                this.formView.render();
                // scroll reordered element into view
                this.parentElement.scrollIntoView();
            }
        });

        // Dropdown select for question type
        let typeSelectorDiv = this.parentElement.appendChild(document.createElement("div"));
        let typeSelectorLabel = typeSelectorDiv.appendChild(document.createElement("label"));
        typeSelectorLabel.className = "form-label";
        typeSelectorLabel.textContent = "Question Type";
        let typeSelector = typeSelectorDiv.appendChild(document.createElement("select"));
        typeSelector.class = "form-select";
        typeSelector.required = true;
        // Include one option for if no question type has been selected yet
        let nullTypeOption = typeSelector.appendChild(document.createElement("option"));
        if (this.question.getTypeID() == null) {
            nullTypeOption.selected = true;
        }
        nullTypeOption.disabled = true;
        this.question.form.getQuestionTypeList().forEach((questionType) => {
            let typeOption = typeSelector.appendChild(document.createElement("option"));
            typeOption.value = questionType["id"];
            typeOption.textContent = questionType["descriptor"];
            if (typeOption.value == this.question.getTypeID()) {
                typeOption.selected = true;
            }
        });
        typeSelector.addEventListener("change", () => {
            // update question type, rerender question view
            let newTypeID = typeSelector.options[typeSelector.selectedIndex].value;
            this.question.setTypeID(newTypeID);
            this.render();
            this.formView.validateInput();
        });

        // Textbox for question text
        let questionTextDiv = this.parentElement.appendChild(document.createElement("div"));
        let questionTextLabel = questionTextDiv.appendChild(document.createElement("label"));
        questionTextLabel.className = "form-label";
        questionTextLabel.textContent = "Question Text";
        let questionTextInput = questionTextDiv.appendChild(document.createElement("textarea"));
        // questionTextInput.type = "text"
        questionTextInput.className = "form-control";
        questionTextInput.required = true;
        // Populate title input box and set it to update stored title on keydown
        questionTextInput.value = this.question.getQuestionText();
        questionTextInput.addEventListener("keyup", () => {
            this.question.setQuestionText(questionTextInput.value);
            this.formView.validateInput();
        });

        // Settings inputs - radio for qualitative, numeric for quantitative
        let settingsDiv = this.parentElement.appendChild(document.createElement("div"));
        this.question.getAvailableSettingsOptions().forEach((option) => {
            let optionDiv = settingsDiv.appendChild(document.createElement("div"));
            let optionLabel = optionDiv.appendChild(document.createElement("label"));
            optionLabel.className = "form-label";
            optionLabel.textContent = option["descriptor"];
            if (option["quantitative"]) {
                // numeric input
                let optionInput = optionDiv.appendChild(document.createElement("input"));
                option.className = "form-control";
                optionInput.type = "number";
                optionInput.min = "0";
                let currentValue = this.question.getAppliedSetting(option["id"]);
                if (currentValue !== null) {
                    optionInput.value = currentValue;
                }
                // event handler to update information on change
                optionInput.addEventListener("input", () => {
                    this.question.applySetting(option["id"], optionInput.value);
                    this.formView.validateInput();
                });
            } else {
                // dropdown input, with one option for each listed value
                let optionInput = optionDiv.appendChild(document.createElement("select"));
                optionInput.className = "form-select";
                this.question.getSettingsValueList(option["id"]).forEach((value) => {
                    let optionInputValue = optionInput.appendChild(document.createElement("option"));
                    optionInputValue.value = value["id"];
                    optionInputValue.textContent = value["descriptor"];
                    if (optionInputValue.value == this.question.getAppliedSetting(option["id"])) {
                        optionInputValue.selected = true;
                    }
                });
                // event handler to update information on change
                optionInput.addEventListener("change", () => {
                    let newValue = optionInput.options[optionInput.selectedIndex].value;
                    this.question.applySetting(option["id"], optionInput.value);
                    this.formView.validateInput();
                });
            }
        });

        // Button to delete question
        let deleteQuestionButton = this.parentElement.appendChild(document.createElement("button"));
        deleteQuestionButton.className = "btn btn-sm btn-danger";
        deleteQuestionButton.textContent = "Delete Question";
        deleteQuestionButton.addEventListener("click", () => {
            this.formView.removeQuestion(this);
        });

        // Horizontal rule to separate questions
        this.parentElement.appendChild(document.createElement("hr"));
    }
}