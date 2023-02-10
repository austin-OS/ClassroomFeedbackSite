// This file contains classes to represent the information associated with
// feedback forms and feedback questions on the front-end, with methods
// to allow convenient access to and modification of nested data
class FeedbackForm {
    // Data representation in JSON, in same format passed from
    // get_form_details method in the FeedbackFormsHelper
    formDetails = {};
    // Track the list of FeedbackQuestion objects associated with this
    // form - the info is already nested in the JSON, but the 
    // encapsulation allows more convenient manipulation of individual
    // questions
    questions = [];

    // Constructor - takes JSON object and stores it, also generates class
    // objects for questions
    constructor(formDetailsJSON) {
        this.formDetails = formDetailsJSON;
        // generate FeedbackQuestion objects
        this.formDetails["questions"].forEach((questionDetails) => {
            this.questions.push(new FeedbackQuestion(this, questionDetails));
        })
    }

    // Getter for own ID
    getID() {
        return this.formDetails["form"]["id"];
    }

    // Getter and setter for title, hiding internal representation
    getTitle() {
        // Handle case where title field isn't initialized
        if (!Object.keys(this.formDetails["form"]).includes("title")) {
            this.formDetails["form"]["title"] = "";
        }
        return this.formDetails["form"]["title"];
    }
    setTitle(newTitle) {
        this.formDetails["form"]["title"] = newTitle;
    }

    // Append a new question object to the end of the list, construct a
    // class object, and return a reference to it
    createQuestion() {
        let questionInfo = {
            id: null,
            question_text: "",
            form_id: this.formDetails["form"]["id"],
            type_id: null,
            order: this.formDetails["questions"].length + 1,
            settings: []
        };
        this.formDetails["questions"].push(questionInfo);
        let questionObject = new FeedbackQuestion(this, questionInfo)
        this.questions.push(questionObject);
        return questionObject;

    }
    // Remove the given question object from the list
    removeQuestion(question) {
        question.setOrder(this.questions.length); // to avoid leaving a "hole" in the ordering
        this.formDetails["questions"].splice(this.formDetails["questions"].indexOf(question.questionDetails), 1)
        this.questions.splice(this.questions.indexOf(question), 1);
    }

    // getter for options info
    getQuestionSettingsOptionList() {
        return this.formDetails["question_settings_options"];
    }
    getQuestionSettingsOptionInfo(optionID) {
        let resultArray = this.getQuestionSettingsOptionList().filter((option) => option["id"] == optionID);
        return (resultArray ? resultArray[0] : null);
    }
    getQuestionSettingsValueList(optionID) {
        return this.getQuestionSettingsOptionInfo(optionID)["values"];
    }
    getQuestionSettingsValueInfo(optionID, valueID) {
        let resultArray = this.getQuestionSettingsValueList(optionID).filter((value) => value["id"] == valueID);
        return (resultArray ? resultArray[0] : null);
    }

    // getter for type info
    getQuestionTypeList() {
        return this.formDetails["question_types"];
    }
    getQuestionTypeInfo(typeID) {
        let resultArray = this.getQuestionTypeList().filter((type) => type["id"] == typeID);
        return (resultArray ? resultArray[0] : null);
    }

    // validate currently-stored info, return a list of reasons, if any, why
    // it can't currently be saved to the databas
    getModelErrors() {
        let errors = [];
        // currently just check for:
        // title missing
        if (this.getTitle() == "") {
            errors.push("Form needs non-empty title");
        }
        // no questions present (not checked in backend, but there's no reason
        // to allow this)
        if (this.questions.length == 0) {
            errors.push("Form needs at least one question");
        }
        // question text missing
        // question type missing
        // min value > max value (for numerical questions)
        // min length > max length for max length != null (for written questions)
        this.questions.forEach((question, index) => {
            if (question.getQuestionText() == "") {
                errors.push(`Question ${index + 1} needs non-blank prompt text`);
            }
            if (question.getTypeID() == null) {
                errors.push(`Question ${index + 1} needs specified input type`);
            }
            if (Number(question.getAppliedSettingByLabel("MIN_VALUE")) > Number(question.getAppliedSettingByLabel("MAX_VALUE"))) {
                errors.push(`Question ${index + 1} attempting to set min value higher than max value`);
            }
            let max_length = question.getAppliedSettingByLabel("MAX_LENGTH");
            if (max_length && parseInt(question.getAppliedSettingByLabel("MIN_LENGTH")) > parseInt(max_length)) {
                errors.push(`Question ${index + 1} attempting to set min length higher than max length`);
            }
        })
        return errors;
    }

}
class FeedbackQuestion {
    // Data representation in JSON, will generally just be a reference to
    // the nested object in the form JSON
    questionDetails = {};
    // Reference to the form object that the question is a part of
    form = null;

    // Constructor - takes the reference to the form object, stores it,
    // and gets the reference to the JSON data by indexing
    constructor(formObject, questionObject) {
        this.questionDetails = questionObject;
        this.form = formObject;
    }

    // Getter for own ID - will return null for newly-created questions
    getID() {
        return this.questionDetails["id"];
    }

    // Getter and setter for question type
    getTypeID() {
        return this.questionDetails["type_id"];
    }
    getTypeInfo() {
        return this.form.getQuestionTypeInfo(this.getTypeID());
    }
    setTypeID(newID) {
        this.questionDetails["type_id"] = newID;
        // validation to make sure type assignment is valid
        if (this.getTypeInfo() == null) {
            window.alert("Question set to invalid type (this shouldn't be appearing unless either the view was designed incorrectly or the user is fiddling with Inspect Element)");
        }
    }

    // Getter and setter for question text
    getQuestionText() {
        return this.questionDetails["question_text"];
    }
    setQuestionText(newText) {
        this.questionDetails["question_text"] = newText;
    }

    // Getters for available settings options
    getAvailableSettingsOptions() {
        // return only options applicable to current type
        let options = this.form.getQuestionSettingsOptionList().filter((option) => option["question_type_id"] == null || option["question_type_id"] == this.getTypeID());
        // put the type-specific ones first to make the interface feel 
        // less cumbersome
        options.sort((a, b) => (a["question_type_id"] == null) - (b["question_type_id"] == null));
        return options;
    }
    getSettingsOptionInfo(optionID) {
        // only returns non-null for applicable options
        let resultArray = this.getAvailableSettingsOptions().filter((option) => option["id"] == optionID);
        return (resultArray ? resultArray[0] : null);
    }
    getSettingsValueList(optionID) {
        return (this.getSettingsOptionInfo(optionID) == null ? [] : this.form.getQuestionSettingsValueList(optionID));
    }
    getSettingsValueInfo(optionID, valueID) {
        let filterResults = this.getSettingsValueList(optionID).filter((value) => value["id"] == valueID);
        return (filterResults == null ? null : filterResults[0]);
    }

    // Getters and setters for applied settings options
    getAppliedSetting(optionID) {
        // return default if no entry present, return value stored in
        // entry otherwise
        let resultArray = this.questionDetails["settings"].filter((setting) => setting["option_id"] == optionID);
        return (resultArray && resultArray.length > 0 ? resultArray[0]["value"] : this.getSettingsOptionInfo(optionID)["default"])
    }
    applySetting(optionID, newValue) {
        // create new entry if one isn't already present, edit existing one
        // otherwise
        let resultArray = this.questionDetails["settings"].filter((setting) => setting["option_id"] == optionID);
        // console.log(resultArray);
        if (resultArray && resultArray.length > 0) {
            resultArray[0]["value"] = newValue;
        } else {
            this.questionDetails["settings"].push({
                id: null,
                question_id: this.getID(),
                option_id: optionID,
                value: newValue
            });
        }
    }

    // For more convenient determination of settings when filling out the form
    // Gets current settings value by internal name of option, also returning
    // internal name of value if option is qualitative
    getAppliedSettingByLabel(optionInternalName) {
        let filterArray = this.getAvailableSettingsOptions().filter((option) => option["internal_name"] == optionInternalName);
        let result = null;
        if (filterArray && filterArray.length > 0) {
            let optionID = filterArray[0]["id"];
            result = this.getAppliedSetting(optionID);
            if (this.getSettingsOptionInfo(optionID)["quantitative"] == false) {
                result = this.getSettingsValueInfo(optionID, result)["internal_name"];
            }
        }
        return result;
    }

    // Getter and setter for question order - setter will update order of 
    // other questions accordingly if "shift" is set to true
    getOrder() {
        return this.questionDetails["order"];
    }
    setOrder(newOrderNum, shift = true) {
        if (this.getOrder() != newOrderNum) {
            // shift the other order numbers to maintain distinctness
            // this isn't necessarily needed, especially considering
            // that question order isn't a unique key or even a required
            // field in the model, but it makes things a little nicer
            if (shift) {
                this.form.questions.forEach((question) => {
                    // if question is being moved backwards, need to 
                    // shift other questions forward to fill gap
                    // and vise versa
                    let order = question.getOrder();
                    if (order > this.getOrder() && order <= newOrderNum) {
                        question.setOrder(order - 1, shift = false);
                    } else if (order < this.getOrder() && order >= newOrderNum) {
                        question.setOrder(order + 1, shift = false);
                    }
                });
            }
            // save new order number
            this.questionDetails["order"] = newOrderNum;
        }
    }

    // Method to delete self - wrapper for corresponding call in form class
    remove() {
        this.form.removeQuestion(this)
    }
}