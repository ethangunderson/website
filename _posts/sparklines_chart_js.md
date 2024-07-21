---
layout: Website.PostLayout
title: Sparklines in Chart.js
date: 2021-09-01
categories: post
permalink: "/sparklines-in-chartjs"
---

A sparkline is a small, simple chart that can be used to show trend information at a glance. There are normally no axes or tooltips, just a small line of data points. While building Glean, I wanted a quick way to show the user how their accounts are performing over time. Sparklines were perfect for this use case.

While Chart.js doesn’t have a first class sparkline chart option, the configurability of line charts still makes this possible without including any other libraries or plugins.

The following code will produce a sparkline in Chart.js version 3.3.2

``` javascript
new Chart(chartContext, {
    type: "line",
    data: {
      labels: series,
      datasets: [
        {
          data: series,
          fill: false,
          pointRadius: 0,
          spanGaps: true,
          tension: 0.2
        },
      ],
    },
    options: {
      events: [],
      borderColor: borderColor,
      borderWidth: 1.5,
      responsive: false,
      plugins: {
        legend: {
          display: false,
          labels: {
            display: false
          }
        },
        tooltips: {
          display: false
        }
      },
      scales: {
        x: {
          display: false,
        },
        y: {
          display: false,
        }
      },
    },
  });
```
