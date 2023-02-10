// This file contains classes for handling the rendering of the interface
// for previewing or filling in the feedback forms
class FeedbackFormView {
    // Reference to FeedbackForm object containing data
    form;
    // List of view objects for rendering views for individual questions
    questionViews = [];
    // Reference to parent DOM object to render in
    parentElement;
    // References to commonly-accessed child elements
    questionContainer;
    submitButton = null;
    submitButtonContainer;
    validationMessageBox;
    // Determine whether to treat as preview or as actual submission
    isPreview;
    feedbackAssignmentID;
    presenterName;

    // Constructor - stores references to form model object, parent
    // element, and submission info, generates question views
    constructor(formObject, parentElement, feedbackAssignmentID=null, presenterName=null) {
        this.form = formObject;
        this.parentElement = parentElement;
        this.form.questions.forEach((question) => {
            this.questionViews.push(new FeedbackQuestionView(this, question, null));
        })
        this.feedbackAssignmentID = feedbackAssignmentID;
        this.presenterName = presenterName;
        this.isPreview = !feedbackAssignmentID;
    }

    // Clear the parent element and render the view inside it
    render(parentElement=this.parentElement) {
        // Store parent element if different than current value
        this.parentElement = parentElement;

        // Set Bootstrap classes on parent elemetn for styling
        this.parentElement.className = "container";

        // Clear current contents
        this.parentElement.innerHTML = "";

        // Render title
        let header = this.parentElement.appendChild(document.createElement("h1"));
        header.textContent = (this.isPreview ? `Preview of ${this.form.getTitle()}` : `Evaluating ${this.presenterName} With ${this.form.getTitle()}`);

        this.parentElement.appendChild(document.createElement("hr"));

        // Render questions
        this.questionContainer = this.parentElement.appendChild(document.createElement("div"));
        this.questionViews.sort((a, b) => a.question.getOrder() - b.question.getOrder());
        this.questionViews.forEach((questionView) => {
            let individualQuestionContainer = this.questionContainer.appendChild(document.createElement("div"));
            questionView.render(individualQuestionContainer);
        });

        // Render textbox for validation messages
        // Render submit button for real submission mode
        // Render edit button for preview mode
        // Render back button in either case
        this.submitButtonContainer = this.parentElement.appendChild(document.createElement("div"));
        this.validationMessageBox = this.submitButtonContainer.appendChild(document.createElement("div"));
        if (this.isPreview) {
            let editButton = this.parentElement.appendChild(document.createElement("a"));
            editButton.className = "btn btn-primary btn-large";
            editButton.textContent = "Edit";
            editButton.href = `/feedback_forms/${this.form.getID()}/edit`;
        }
        else {
            this.submitButton = this.submitButtonContainer.appendChild(document.createElement("button"));
            this.submitButton.className = "btn btn-success btn-large";
            this.submitButton.textContent = "Submit";
            this.submitButton.addEventListener("click", () => {
                // store the form JSON in an invisible input element and POST
                // to feedback_forms#create route
                // code adapted from https://stackoverflow.com/a/43021899
                let submissionForm = document.createElement("form");
                submissionForm.style.visibility = "hidden";
                submissionForm.method = "POST";
                submissionForm.action = "/feedback_responses";
                let idInput = document.createElement("input");
                idInput.name = "assignment_id";
                idInput.value = this.feedbackAssignmentID;
                submissionForm.appendChild(idInput);
                let responsesInput = document.createElement("input");
                responsesInput.name = "responses";
                responsesInput.value = JSON.stringify(
                    this.questionViews.map((questionView) => {
                        return {
                            question_id: questionView.question.getID(), 
                            value: questionView.getValue(),
                        };
                    })
                );
                submissionForm.appendChild(responsesInput);
                this.parentElement.appendChild(submissionForm);
                submissionForm.submit();
            });
        }
        let backButton = this.parentElement.appendChild(document.createElement("a"));
        backButton.className = "btn btn-danger btn-large";
        backButton.textContent = (this.isPreview ? "Back" : "Cancel") ;
        backButton.href = (this.isPreview ? "/feedback_forms" : "javascript:history.back()");

        this.validateInput();
    }

    // Method for checking whether response constraints have been met and
    // notifying user and enabling/disabling submit button accordingly
    validateInput() {
        let errors = [];
        this.questionViews.forEach((questionView) => {
            questionView.appendErrors(errors);
        });
        if (errors.length == 0) {
            // If no errors, clear message box and enable button if present
            this.validationMessageBox.innerHTML = "";
            if (this.submitButton) {
                this.submitButton.disabled = false;
            }
        } else {
            // Otherwise, populate message box and disable button if present
            // disable button
            if (this.submitButton) {
                this.submitButton.disabled = true;
            }
            // set validation message
            let tooltipText = "The following issues need to be corrected before the form can be saved:";
            tooltipText += "<ul>";
            errors.forEach((error) => {
                tooltipText += `<li>${error}</li>`;
            })
            tooltipText += "</ul>";
            this.validationMessageBox.innerHTML = tooltipText;
        }
    }
}

class FeedbackQuestionView {
    // Reference to FeedbackQuestion object containing data
    question;
    // Reference to view object for form
    formView;
    // Reference to parent DOM object to render in
    parentElement;
    // Reference to element containing current input value
    inputElement;
    // Other commonly-accessed info
    questionTypeLabel;

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

        // Clear current contents
        this.parentElement.innerHTML = "";

        // Render order number and question text
        let questionNum = this.parentElement.appendChild(document.createElement("p"));
        questionNum.innerHTML = `<strong>Question ${this.question.getOrder()}</strong>`
        let prompt = this.parentElement.appendChild(document.createElement("p"));
        prompt.textContent = this.question.getQuestionText();

        // Render input
        // Numeric for numeric scale, textbox for written response
        this.questionTypeLabel = this.question.getTypeInfo()["internal_name"];
        if (this.questionTypeLabel == "SCALE") {
            this.inputElement = this.parentElement.appendChild(document.createElement("input"));
            this.inputElement.className = "form-control";
            this.inputElement.type = "number";
            
            // keep track of value constraints
            this.inputElement.min = this.getSetting("MIN_VALUE");
            this.inputElement.max = this.getSetting("MAX_VALUE");

            // rerun validity checks whenever inputs change
            this.inputElement.addEventListener("input", () => {
                this.formView.validateInput();
            });

            let rangeIndicator = this.parentElement.appendChild(document.createElement("small"));
            rangeIndicator.textContent = `Min: ${this.inputElement.min}, Max: ${this.inputElement.max}`;
        } else if (this.questionTypeLabel == "TEXT") {
            this.inputElement = this.parentElement.appendChild(document.createElement("textarea"));
            this.inputElement.className = "form-control";

            // keep track of length constraints
            let maxLength = this.getSetting("MAX_LENGTH");
            let minLength = this.getSetting("MIN_LENGTH");
            if (maxLength) {
                this.inputElement.maxLength = maxLength;
            }

            let lengthRangeIndicator = this.parentElement.appendChild(document.createElement("small"));
            lengthRangeIndicator.innerHTML = `${(minLength ? "Min length: " + minLength + ", " : "")}${(maxLength ? "Max length: " + maxLength + ", " : "")}Current length: <span class="currentLengthIndicator">${this.inputElement.value.length}</span>`;

            // rerun validity checks whenever inputs change
            this.inputElement.addEventListener("keyup", () => {
                this.formView.validateInput();
                this.parentElement.querySelector(".currentLengthIndicator").textContent = this.inputElement.value.length;
            });
        }

        // Render info about settings
        this.parentElement.appendChild(document.createElement("br"));
        let requiredIndicator = this.parentElement.appendChild(document.createElement("small"));
        requiredIndicator.textContent = `This question is ${this.getSetting("REQUIRED") == "TRUE" ? "required" : "optional"}`;
        
        this.parentElement.appendChild(document.createElement("br"));
        let visibilityIndicator = this.parentElement.appendChild(document.createElement("small"));
        visibilityIndicator.textContent = `Responses are visible to ${this.getSetting("RELEASE_TO").toLowerCase().replace(/_/g, " ")}`;

        this.parentElement.appendChild(document.createElement("br"));
        let anonymityIndicator = this.parentElement.appendChild(document.createElement("small"));
        anonymityIndicator.textContent = `Respondent identities are visible to ${this.getSetting("DEANONYMIZATION").toLowerCase().replace(/_/g, " ")}`;

        this.parentElement.append(document.createElement("hr"));
    }

    // Retrieve current value from input
    getValue() {
        return this.inputElement.value;
    }

    // Retrieve setting value label by option type label
    getSetting(optionLabel) {
        return this.question.getAppliedSettingByLabel(optionLabel);
    }

    // Record any issues with current input values, for use with validateInput
    appendErrors(errors) {
        let questionLabel = `Question ${this.question.getOrder()}`
        // Check if question is required but not filled
        if (this.getSetting("REQUIRED") == "TRUE" && this.getValue() == "") {
            errors.push(`${questionLabel} needs a non-empty response`);
        }

        // Check if value is out of bounds
        if (this.questionTypeLabel == "SCALE") {
            if (parseInt(this.getValue()) < parseInt(this.getSetting("MIN_VALUE"))) {
                errors.push(`${questionLabel}'s current value is too small`);
            } else if (parseInt(this.getValue()) > parseInt(this.getSetting("MAX_VALUE"))) {
                errors.push(`${questionLabel}'s current value is too large`);
            } 
        } else if (this.questionTypeLabel == "TEXT") {
            // Check if value is too long or too short
            let minLength = this.getSetting("MIN_LENGTH");
            let maxLength = this.getSetting("MAX_LENGTH");
            if (minLength && this.getValue().length < parseInt(minLength)) {
                errors.push(`${questionLabel}'s current response is too short`);
            } else if (maxLength && this.getValue().length > parseInt(maxLength)) {
                errors.push(`${questionLabel}'s current response is too long`);
            } 
        }
    }

}