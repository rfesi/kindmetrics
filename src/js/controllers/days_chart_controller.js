import { Controller } from "stimulus"
import Chart from 'chart.js'
export default class extends Controller {

  createChart(ctx, response) {
    console.log("inside create")
    console.log(response)

    const { labels, today, data } = response

    var gradientFill = ctx.getContext("2d").createLinearGradient(0, 260, 0, 0);
    gradientFill.addColorStop(0, "rgba(255,255,255,0.1)");
    gradientFill.addColorStop(1, "rgba(48, 71, 94, 0.3)");

    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: labels,
            datasets: [{
              backgroundColor: gradientFill,
              borderColor: 'rgba(48, 71, 94, 1)',
              lineTension: 0,
              pointBackgroundColor: 'rgba(48, 71, 94, 1)',
              label: 'Visitors',
              data: data
            }, {
              backgroundColor: gradientFill,
              borderColor: 'rgba(48, 71, 94, 1)',
              borderDash: [5, 15],
              lineTension: 0,
              pointBackgroundColor: 'rgba(48, 71, 94, 1)',
              label: 'Visitors',
              data: today
            }]
        },

        // Configuration options go here
        options: {
          legend: {
              display: false
          },
          maintainAspectRatio: false
        }
    });
  }

  getData() {
    this.element.innerHTML = this.loader()
    const period = this.data.get("period") ? this.data.get("period") : "7d"
    fetch(this.data.get("url") + "?period=" + period).then(response => {
      return response.json()
    }).then(response => {
      return this.createChart(this.element, response)
    })
  }

  connect() {
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 m-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }
}
