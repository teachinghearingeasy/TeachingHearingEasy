const questionContainers = document.querySelectorAll('.question-container');
const nextBtn = document.querySelector('.next-question-btn');
const prevBtn = document.querySelector('.prev-question-btn');
const progressBar = document.querySelector('.progress-bar');
let currentQuestionIndex = 0;

// Function to update progress bar
function updateProgressBar() {
        const totalQuestionsCount = questionContainers.length;
        const progressPercentage = (currentQuestionIndex * 100 / (totalQuestionsCount - 1));
        progressBar.style.width = progressPercentage + '%';
        progressBar.setAttribute('aria-valuenow', progressPercentage);
}


if (nextBtn != null && prevBtn !=null) {
        // Next button click event
        nextBtn.addEventListener('click', function() {
                if (currentQuestionIndex < questionContainers.length - 1) {
                        questionContainers[currentQuestionIndex].classList.add('d-none');
                        currentQuestionIndex++;
                        questionContainers[currentQuestionIndex].classList.remove('d-none');
                        updateProgressBar();
                }
        });

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


        function updateProgressBar() {
                let totalQuestionsCount = questionContainers.length;
                let progressPercentage = (currentQuestionIndex * 100 / (totalQuestionsCount - 1));
                progressBar.style.width = progressPercentage + '%';
                progressBar.setAttribute('aria-valuenow', progressPercentage);
        }

        if (nextBtn != null && prevBtn !=null) {
                // Next button click event
                nextBtn.addEventListener('click', function() {
                        if (currentQuestionIndex < questionContainers.length - 1) {
                                questionContainers[currentQuestionIndex].classList.add('d-none');
                                currentQuestionIndex++;
                                questionContainers[currentQuestionIndex].classList.remove('d-none');
                                updateProgressBar();
                        }
                });

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
