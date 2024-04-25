const questionContainers = document.querySelectorAll('.question-container');
const nextBtn = document.querySelector('.next-question-btn');
const checkButton = document.querySelector('.check-question-btn');
const prevBtn = document.querySelector('.prev-question-btn');
let progressBar = document.querySelector('.progress-bar');
let currentQuestionIndex = 0;

// Function to update progress bar
function updateProgressBar() {
    const totalQuestionsCount = questionContainers.length;
    const progressPercentage = ((currentQuestionIndex + 1) * 100 / (totalQuestionsCount));
    progressBar.style.width = progressPercentage + '%';
    progressBar.setAttribute('aria-valuenow', progressPercentage);

    if (currentQuestionIndex === (totalQuestionsCount - 1)) {
        nextBtn.style.display = "none";
    } else {
        nextBtn.style.display = "inline";
    }

    if (currentQuestionIndex === 0) {
        prevBtn.style.display = "none";
    } else {
        prevBtn.style.display = "inline";
    }
}

if (nextBtn != null) {
    // Next button click event
    nextBtn.addEventListener('click', function () {
        if (currentQuestionIndex < questionContainers.length - 1) {
            questionContainers[currentQuestionIndex].classList.add('d-none');
            currentQuestionIndex++;
            questionContainers[currentQuestionIndex].classList.remove('d-none');
            updateProgressBar();
        }
    });
}

if (prevBtn != null) {
    // Previous button click event
    prevBtn.addEventListener('click', function () {
        if (currentQuestionIndex > 0) {
            questionContainers[currentQuestionIndex].classList.add('d-none');
            currentQuestionIndex--;
            questionContainers[currentQuestionIndex].classList.remove('d-none');
            updateProgressBar();
        }
    });
}


const ratingButtons = document.querySelectorAll('.rating-btn');
ratingButtons.forEach(function (button) {
    button.addEventListener('click', function (e) {
        e.preventDefault();
        const rating = this.getAttribute('data-rating');
        const ratingField = this.parentElement.querySelector('.rating-field');
        ratingField.value = rating;
        // Remove active class from all buttons in this group
        this.parentElement.querySelectorAll('.rating-btn').forEach(function (btn) {
            btn.classList.remove('active');
        });
        // Add active class to clicked button
        this.classList.add('active');
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const questionContainers = document.querySelectorAll('.question-container');
    const nextBtn = document.querySelector('.next-question-btn');
    const prevBtn = document.querySelector('.prev-question-btn');
    const checkButton = document.querySelectorAll('[id^=\'check-question-btn-\']');
    const progressBar = document.querySelector('.progress-bar');
    let currentQuestionIndex = 0;
    const ratingButtons = document.querySelectorAll('.rating-btn');

    // Logic for save button
    const submitQuizButton = document.querySelector('.submit-quiz-button');
    const completeField = document.querySelector('.complete-tag');
    if (submitQuizButton != null) {
        submitQuizButton.addEventListener('click', function () {
            completeField.value = 'true';
        });
    }
    const anchorSampleButtons = document.querySelectorAll("[id^='button_anchor_']");
    if (anchorSampleButtons != null) {
        anchorSampleButtons.forEach(function (button) {
            button.addEventListener('click', function () {
                let id_contents = button.id.split("_");
                let anchor_id = "#audio_elem_anchor_" + id_contents.at(id_contents.length - 1)
                document.querySelector(anchor_id).style.display = "inline";
                button.style.display = "none";
            })
        });
    }

    // Fill in saved responses (this should work for tests as well)
    questionContainers.forEach((container, index) => {
        // Get the rating and reasoning fields
        const gRatingField = document.querySelector(`.response-${index}-g-rating`);
        const rRatingField = document.querySelector(`.response-${index}-r-rating`);
        const bRatingField = document.querySelector(`.response-${index}-b-rating`);
        const aRatingField = document.querySelector(`.response-${index}-a-rating`);
        const sRatingField = document.querySelector(`.response-${index}-s-rating`);
        const reasoningField = document.querySelector(`.response-${index}-reasoning`);

        // Get the rating buttons
        const ratingButtons = container.querySelectorAll('.rating-btn');
        // Highlight the button that corresponds to the saved rating
        const quiz = ratingButtons.length === 4
        const letters = [gRatingField, rRatingField, bRatingField, aRatingField, sRatingField]
        const range = [0, 4, 8, 12, 16, 20]
        for (let i = 0; i < ratingButtons.length; i++) {
            const button = ratingButtons[i];
            if (!quiz){
                index = 0;
                for (let j = 0; j < range.length - 1; j++) {
                    if (i >= range[j] && i < range[j + 1]) {
                        index = j;
                        break;
                    }
                }
                if (letters[index].value && button.getAttribute('data-rating') === letters[index].value) {
                    button.classList.add('active');
                    const ratingField = button.parentElement.querySelector('.rating-field');
                    ratingField.value = letters[index].value;
                    letters[index].value = '';
                }
            } else {
                for (let j = 0; j < letters.length; j++) {
                    if (letters[j].value && button.getAttribute('data-rating') === letters[j].value) {
                        button.classList.add('active');
                        const ratingField = button.parentElement.querySelector('.rating-field');
                        ratingField.value = letters[j].value;
                    }
                }
            }
        }

        // Fill in the reasoning
        if (reasoningField.value) {
            container.querySelector('.reasoning-field').value = reasoningField.value;
        }
    });

    function updateProgressBar() {
        let totalQuestionsCount = questionContainers.length;
        let progressPercentage = ((currentQuestionIndex + 1) * 100 / (totalQuestionsCount));
        progressBar.style.width = progressPercentage + '%';
        progressBar.setAttribute('aria-valuenow', progressPercentage);

        if (currentQuestionIndex === (totalQuestionsCount - 1)) {
            nextBtn.style.display = "none";
        } else {
            nextBtn.style.display = "inline";
        }

        if (currentQuestionIndex === 0) {
            prevBtn.style.display = "none";
        } else {
            prevBtn.style.display = "inline";
        }
    }

    function checkForAudio() {
        // let audio_elem = document.querySelector("[id^='audio_elem_']");
        // console.log(audio_elem)
        if (document.querySelectorAll("[id^='audio_elem_']") != null) {
            //console.log("called pause")
            document.querySelectorAll("[id^='audio_elem_']").forEach(elem => {
                    elem.pause();
                }
            )
        }
    }

    if (nextBtn != null) {
        // Next button click event
        nextBtn.addEventListener('click', function () {
            if (currentQuestionIndex < questionContainers.length-1) {
                // Move progress bar to next question
                questionContainers[currentQuestionIndex].classList.add('d-none');
                currentQuestionIndex++;
                questionContainers[currentQuestionIndex].classList.remove('d-none');
                updateProgressBar();
                checkForAudio();
            }
        });
    }

    if (prevBtn != null) {
        // Previous button click event
        prevBtn.addEventListener('click', function () {
            if (currentQuestionIndex > 0) {
                questionContainers[currentQuestionIndex].classList.add('d-none');
                currentQuestionIndex--;
                questionContainers[currentQuestionIndex].classList.remove('d-none');
                updateProgressBar();
                checkForAudio();
            }
        });
    }

    console.log(checkButton);

    if (checkButton != null) {
        checkButton.forEach(function (button) {
            button.addEventListener('click', function (e) {
                // Show modal with answer check result
                if (document.querySelector(`.answer-${currentQuestionIndex}`) != null) {
                    const userAnswer = document.querySelectorAll('.rating-btn.active')[currentQuestionIndex].getAttribute('data-rating');
                    const correctAnswer = document.querySelector(`.answer-${currentQuestionIndex}`).value;
                    let answerCheckResult;
                    if (userAnswer === correctAnswer) {
                        answerCheckResult = 'Your answer is correct!';
                    } else if (userAnswer < correctAnswer) {
                        answerCheckResult = 'You put ' + userAnswer + '. The correct answer is rated higher.';
                    } else {
                        answerCheckResult = 'You put ' + userAnswer + '. The correct answer is rated lower.';
                    }
                    document.getElementById('answerModalLabel').textContent = 'Question ' + (currentQuestionIndex
                        + 1) + ' Check';
                    document.getElementById('answerModalBody').textContent = answerCheckResult;
                    $('#answerModal').modal('show');
                }
            });
        })
    }

    ratingButtons.forEach(function (button) {
        button.addEventListener('click', function (e) {
            e.preventDefault();
            const rating = this.getAttribute('data-rating');
            const ratingField = this.parentElement.querySelector('.rating-field');
            ratingField.value = rating;
            // Remove active class from all buttons in this group
            this.parentElement.querySelectorAll('.rating-btn').forEach(function (btn) {
                btn.classList.remove('active');
            });
            // Add active class to clicked button
            this.classList.add('active');
        });
    });
});
