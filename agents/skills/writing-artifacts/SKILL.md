---
name: writing-artifacts
description: >-
  Durable artifact writing for a specific reader and action. Use for work
  contracts, handoffs, decision proposals or records, evidence reports, user
  or operator guides, and maintainer references.
---

# Writing artifacts

A durable artifact must stand without the conversation and enable one primary
reader action.

## Select the contract

Choose one artifact contract and one primary audience. Classify by the reader's
action. An RFC seeking approval is a decision proposal. An accepted implementation
spec is a work contract.

| Contract | Artifact types | Primary audience | Enabled action | Reference |
|---|---|---|---|---|
| Work contract | task, issue, implementation spec | implementation owner | implement and prove | `references/work-contract.md` |
| Handoff | session handoff, checkpoint | next worker without chat | resume safely | `references/handoff.md` |
| Decision proposal | RFC, design proposal | decision owner | evaluate and decide | `references/decision-proposal.md` |
| Decision record | ADR, accepted design note | future maintainer | apply or revisit a decision | `references/decision-record.md` |
| Evidence report | investigation, status report, postmortem | response owner | assess evidence and act | `references/evidence-report.md` |
| User or operator guide | usage README, how-to, runbook | person performing the task | complete or recover | `references/user-guide.md` |
| Maintainer reference | architecture guide, internal reference | maintainer | locate truth and change safely | `references/maintainer-reference.md` |

Infer the contract and audience from the request and repository. Ask only when
the choice changes the document materially. Split unrelated audiences or
actions. A shared entry document may keep clearly separated audience sections.

## Reader

State the knowledge the document may assume.

- Internal implementer, reviewer, or maintainer: default to expert.
- User or operator: assume only prerequisites named by the document.
- External decision-maker: explain domain detail only when it affects the decision.

## Shared contract

- Stand alone without hidden chat context.
- Lead with the final state, decision, observed behavior, or enabled action.
- Include context only when it changes understanding, trust, or action.
- Anchor material claims to code, tests, history, measurements, or primary sources.
- Separate fact, inference, contradiction, and open uncertainty.
- Repair stale truth before extending the document.
- Load the reference for the selected artifact contract.

## Completion

The primary reader can recover the relevant state, verify material claims, and
take the intended action without access to the conversation.
