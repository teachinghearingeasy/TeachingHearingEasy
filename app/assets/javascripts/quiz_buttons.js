const questionContainers = document.querySelectorAll('.question-container');
const nextBtn = document.querySelector('.next-question-btn');
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
        }
        else
        {
                nextBtn.style.display = "inline";
        }

        if (currentQuestionIndex === 0) {
                prevBtn.style.display = "none";
        }
        else
        {
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
        prevBtn.addEventListener('click', function() {
                if (currentQuestionIndex > 0) {
                        questionContainers[currentQuestionIndex].classList.add('d-none');
                        currentQuestionIndex--;
                        questionContainers[currentQuestionIndex].classList.remove('d-none');
                        updateProgressBar();
                }
        });
}



const ratingButtons = document.querySelectorAll('.rating-btn');
ratingButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
                e.preventDefault();
                const rating = this.getAttribute('data-rating');
                const ratingField = this.parentElement.querySelector('.rating-field');
                ratingField.value = rating;
                // Remove active class from all buttons in this group
                this.parentElement.querySelectorAll('.rating-btn').forEach(function(btn) {
                        btn.classList.remove('active');
                });
                // Add active class to clicked button
                this.classList.add('active');
        });
});

document.addEventListener("DOMContentLoaded", function() {
        const questionContainers = document.querySelectorAll('.question-container');
        const nextBtn = document.querySelector('.next-question-btn');
        const prevBtn = document.querySelector('.prev-question-btn');
        const progressBar = document.querySelector('.progress-bar');
        let currentQuestionIndex = 0;
        const ratingButtons = document.querySelectorAll('.rating-btn');

        // Logic for save button
        const submitQuizButton = document.querySelector('.submit-quiz-button');
        const completeField = document.querySelector('.complete-tag');
        submitQuizButton.addEventListener('click', function() {
                completeField.value = 'true';
        });

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
                ratingButtons.forEach(button => {
                    if (gRatingField.value && button.getAttribute('data-rating') == gRatingField.value) {
                        button.classList.add('active');
                    }
                    if (rRatingField.value && button.getAttribute('data-rating') == rRatingField.value) {
                        button.classList.add('active');
                    }
                    if (bRatingField.value && button.getAttribute('data-rating') == bRatingField.value) {
                        button.classList.add('active');
                    }
                    if (aRatingField.value && button.getAttribute('data-rating') == aRatingField.value) {
                        button.classList.add('active');
                    }
                    if (sRatingField.value && button.getAttribute('data-rating') == sRatingField.value) {
                        button.classList.add('active');
                    }
                });

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
                }
                else
                {
                        nextBtn.style.display = "inline";
                }

                if (currentQuestionIndex === 0) {
                        prevBtn.style.display = "none";
                }
                else
                {
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
                prevBtn.addEventListener('click', function() {
                        if (currentQuestionIndex > 0) {
                                questionContainers[currentQuestionIndex].classList.add('d-none');
                                currentQuestionIndex--;
                                questionContainers[currentQuestionIndex].classList.remove('d-none');
                                updateProgressBar();
                        }
                });
        }

        ratingButtons.forEach(function(button) {
                button.addEventListener('click', function(e) {
                        e.preventDefault();
                        const rating = this.getAttribute('data-rating');
                        const ratingField = this.parentElement.querySelector('.rating-field');
                        ratingField.value = rating;
                        // Remove active class from all buttons in this group
                        this.parentElement.querySelectorAll('.rating-btn').forEach(function(btn) {
                                btn.classList.remove('active');
                        });
                        // Add active class to clicked button
                        this.classList.add('active');
                });
        });
});
