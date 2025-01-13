---
layout: Website.PostLayout
title: "SLOs and SLAs are not Interchangeable Terms"
date: 2024-10-30
categories: post
permalink: "/slos-and-slas-are-not-interchangeable-terms"
description: "These two things are similar, but different. Let's learn the difference."
---

I'm a self-proclaimed SLA/SLO cop. I’m passionate about using the correct terms. Misunderstanding these two terms can lead to serious issues in service operations. Let’s clarify the differences:

* **Service Level Indicator (SLI):** A specific measurement of service performance, such as latency or error rates.

* **Service Level Objective (SLO):** A target for those measurements—what we aspire to achieve.

* **Service Level Agreement (SLA):** A formal contract that outlines expected service levels and penalties for non-compliance.

#### Why This Matters

SLAs are **contracts**. If a service violates the terms of the SLA, there are consequences. Normally, someone owes someone money, in some form or another.

In contrast, SLOs are **goals**. While an SLI represents the current reality of service performance, an SLO defines what we aim for. SLOs are designed to be flexible; they can evolve as your service and business needs change. When an SLO is not met, it’s an opportunity to ask important questions: "Is this target still relevant? Do we need to adjust our goals?" or "How can we improve in this area?" In other words, an SLO violation opens the door for constructive conversation.

SLAs are not mutable. At least, not without a lot of paperwork and lawyers. They are set in stone. They are what you are legally bound to uphold.

An SLA violation should be a significant event (and hopefully a rare event). However, mislabeling SLOs as SLAs will trivialize SLA violations, while mistaking SLAs for SLOs will lead to treating flexible goals as immutable contracts, ultimately undermining their intended value.

#### In Summary

* **SLOs = Goals (mutable)**
* **SLAs = Contracts (fixed)**
