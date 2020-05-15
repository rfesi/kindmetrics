import Chart from 'chart.js';
export function getChart(ref) {
  const createChart = function(ctx, response) {
    console.log("inside create")
    console.log(response)

    const { labels, today, data } = response

    var gradientFill = ctx.getContext("2d").createLinearGradient(0, 260, 0, 0);
    gradientFill.addColorStop(0, "rgba(255,255,255,1)");
    gradientFill.addColorStop(1, "rgba(68,132,206,1)");

    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: labels,
            datasets: [{
              backgroundColor: gradientFill,
              borderColor: 'rgba(68,132,206,1)',
              data: data
            }, {
              backgroundColor: gradientFill,
              borderColor: 'rgba(68,132,206,1)',
              borderDash: [5, 15],
              data: today
            }]
        },

        // Configuration options go here
        options: {
          maintainAspectRatio: false
        }
    });
  }
  fetch(ref.getAttribute("data-url")).then(response => {
    return response.json()
  }).then(response => {
    return createChart(ref, response)
  })
}