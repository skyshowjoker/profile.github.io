# Mercedes-Benz Financial Services China AI Hub — Conversational Interview Answers

> Based on `resume-mercedes-ai-cn.html` and the Chinese interview guide.  
> Use this as a speaking guide, not a script. Replace every `[please add actual details]` placeholder with verified information, and never present a design idea as something you already shipped.

## How to Answer Naturally

- For project questions, use: context, my role, what I did, result, and what I learned.
- For metrics, explain the definition, baseline, test conditions, and business impact.
- For architecture questions, clarify requirements first, then cover the main flow, failure handling, security, observability, and trade-offs.
- If something was not part of your actual project, say, “I didn’t implement that part directly, but this is how I would design it.”
- In financial AI, keep coming back to evidence, human review, least privilege, auditability, and rollback.

---

## 1. Introduction and Resume Validation

### 1. Please introduce yourself in three minutes and explain why you’re a good fit for the Mercedes-Benz Financial Services AI Hub.

I have five years of enterprise software engineering experience, and I’d summarize my background in three areas. First, AI agent engineering. At Huawei, I work on cloud-side AI agent development for Xiaoyi, including multi-agent scheduling, parallel execution, long-running task recovery, intent recognition, and taking prototypes toward production. I’ve worked on Task Space, VibeSkill, AI Mobile Cards, and AIPPT.

Second, financial technology. I spent four years at Citi building a global liquidity risk management platform, so I’m familiar with permissions, auditability, change control, security, and working with international teams. Third, I have hands-on machine learning research experience with nnU-Net and XGBoost, with two research publications.

What makes me a good fit is the combination. This role is not only about calling an LLM. It’s about turning an idea into a PoC and then making it reliable, compliant, and maintainable in production. That’s exactly where my AI, engineering, and financial-services experience come together.

### 2. Pick one Huawei project and one Citi project that best represent your strengths.

At Huawei, I’d choose AI Mobile Card Generation. It combines intent understanding, agent orchestration, mobile capability integration, network topology, delivery management, and production release. It shows that I can work across the whole path from a quick prototype to a real product.

At Citi, I’d choose the dynamic table engine. Users had been relying heavily on Excel, which created efficiency, compliance, and data-security problems. I led a low-code engine for template configuration, storage, calculation, and export. It reduced the related development cost by about 90% and showed my ability to turn a business pain point into a reusable enterprise platform.

### 3. What advantage did your traditional financial-software background give you when moving into AI agents?

My main advantage is that I don’t see an AI application as just a model endpoint. My banking background makes me think about permissions, audit trails, idempotency, rollback, data boundaries, and production stability from day one. My agent experience adds intent recognition, planning, tool use, state management, and evaluation. Together, that helps me decide which parts should use an LLM and which parts need deterministic rules.

### 4. Rank your AI projects by technical difficulty and business value.

In terms of technical difficulty, I’d put Task Space first because it involves open-ended goal decomposition, dynamic planning, tool use, long-running state, and final artifact delivery. AI Mobile Cards would be second because of cross-device orchestration, permissions, topology, and release complexity. VibeSkill comes next because it converts natural language into reusable workflows. AIPPT is more focused on research, content organization, and layout.

For business value, I’d base the ranking on real adoption, usage frequency, time saved, and revenue or conversion. AI Mobile Cards and AIPPT were closer to concrete delivery, Task Space has broader platform value, and VibeSkill has strong reuse and ecosystem potential. I’d support the final ranking with `[please add actual users, revenue, or hours saved]`.

### 5. Are you strongest in agent engineering, model algorithms, or platform engineering?

I’m strongest at the intersection of agent engineering and platform engineering. I’m good at turning model capabilities into stable services: orchestration, context management, tool protocols, long-running tasks, configuration, deployment, and monitoring. I also have hands-on PyTorch, nnU-Net, and XGBoost experience, but my strongest differentiator is engineering AI applications for enterprise production.

### 6. What role would you like to take in the AI Hub?

I’d like to start as a senior individual contributor or technical lead. I can own use-case clarification, PoC design, core architecture, and implementation, while also building reusable components, evaluation standards, and safety controls. As I learn more about Mercedes-Benz Financial Services, I’d like to take on broader platform planning and technical governance responsibilities.

---

## 2. AI Agents and LLM Applications

### 7. Walk me through the architecture from a user request to the final result in Xiaoyi.

I’d break it into seven layers. First is the user and session layer. Then we have identity, safety, and permissions. The routing layer identifies the task. The planning layer turns the goal into a dependency graph. The orchestration layer schedules the main agent, subagents, and tools. The state layer stores sessions, tasks, steps, and artifacts. Finally, the result layer validates and assembles reports, slides, cards, or files. Across all of that, we need a model gateway, prompt and skill configuration, metrics, tracing, audit logs, and controlled rollout.

### 8. How does a multi-agent scheduler break down, assign, and execute tasks?

I first turn the user’s goal into structured tasks with a goal, inputs, outputs, dependencies, permissions, timeout, and completion criteria. Those tasks form a DAG or a dynamic task tree. The scheduler looks at dependencies and an agent capability registry, then sends independent tasks out in parallel. Results are written back to task state and a shared artifact store. If something fails, the system decides whether to retry, degrade, re-plan, or ask the user based on the error type.

### 9. How do you decide whether tasks should run sequentially or in parallel?

The key is dependency and side effects. If task B needs task A’s output, they have to run sequentially. If two tasks are independent and resources are available, they can run in parallel. If both tasks write to the same resource, I may still serialize them or use locking and version control. I also consider model quotas, tool rate limits, cost, and how difficult it will be to merge the results.

### 10. How do you store short-term memory, long-term memory, and task progress?

Short-term memory contains the current conversation, recent messages, and a structured summary. Long-term memory should only contain user-approved preferences or reusable knowledge, with retention and deletion policies. Task progress is persisted with a task ID, step ID, state machine, input and output hashes, and checkpoints. Large files go to object storage, while the state store keeps references. Sensitive content needs encryption and access control.

### 11. How do you resume a long-running task without calling the same tool twice?

Every step needs persistent state and an idempotency key. Before a tool call, I record that the step is pending or running. After success, I store the result, output hash, and external transaction ID before moving the state forward. When recovering, I start from the latest successful checkpoint and check whether the external action already happened. For non-idempotent operations, I use business keys, deduplication, an outbox pattern, or human confirmation.

### 12. What’s the difference between MCP, REST APIs, and model function calling?

REST is a general service communication style. Function calling is how a model selects from predefined functions. MCP goes a step further and standardizes how AI clients discover and use tools, resources, and prompt templates. It doesn’t replace REST; an MCP server may still call REST internally. Its real value is reducing coupling and giving different agent clients a consistent way to access capabilities.

### 13. What problem does A2A solve, and how does it work with MCP?

A2A is mainly about agent-to-agent collaboration: capability discovery, task delegation, status exchange, and result sharing. MCP is mainly about how an agent accesses tools and resources. For example, a main agent could delegate research to a research agent through A2A. That research agent could then use MCP to call search, database, and document tools, and finally return a structured result through A2A.

### 14. How do you isolate a subagent’s context and combine its result?

I only pass the minimum context, permissions, and output schema needed for that task. I don’t copy the entire conversation. Each subagent gets its own context window, tool allowlist, and resource budget. It returns a structured result with conclusions, evidence, confidence, errors, and artifact references. The main agent then checks duplicates and conflicts before combining everything.

### 15. What if multiple agents edit the same file or record?

My first choice is to avoid shared writes. I let agents create independent artifacts and use one merge step. If they must write to the same resource, I use optimistic locking, version numbers, field ownership, branches, or patch-based merging. At commit time, I compare the base version. If there’s a conflict, I re-read, merge, or ask for human review. Database constraints still provide the final protection.

### 16. When should you not use a multi-agent architecture?

If the task is simple, fixed, latency-sensitive, cost-sensitive, or highly deterministic, a single agent, workflow engine, or ordinary service is usually better. Multi-agent systems add context-transfer cost, error propagation, debugging difficulty, and evaluation complexity. I only use them when the task naturally decomposes, needs specialized capabilities, or gets a clear benefit from parallel execution.

### 17. What does the 92%+ intent accuracy actually mean?

I’d be very specific: it refers to classification accuracy on a test set for key business scenarios, not every open-ended user request. It’s the number of predictions matching human labels divided by the total number of samples. I’d also show per-class precision, recall, and a confusion matrix so large classes don’t hide weak small classes. I still need to add the verified `[sample size, number of intents, and baseline]`.

### 18. How would you build the test set and avoid imbalance or leakage?

I’d sample from anonymized real requests, standard product cases, and adversarial edge cases. At least two people should label the data independently and resolve disagreements. I’d split by user or time rather than randomly mixing similar expressions. For rare intents, I’d use stratified sampling and report macro F1. I’d also keep a frozen final test set that prompt developers don’t repeatedly tune against.

### 19. What changed before and after prompt optimization?

Typical changes include a clearer role and scope, explicit intent definitions, counterexamples, a defined decision order, structured output, confidence, and a clarification policy. I’d make the differences between easily confused intents very explicit. For evaluation, I’d keep the model and parameters fixed and compare accuracy, F1, format success, token usage, and latency on the same dataset.

### 20. How do you tell whether the problem is the prompt, the model, or the business rules?

I start with a minimal reproducible case. If clearer instructions or examples consistently fix it, it’s probably a prompt issue. If different prompts still fail on the same reasoning or knowledge task, it may be a model limitation. If business experts disagree on the right answer, then the business definition is the real issue. A stronger model and a rule-based baseline can also help establish upper and lower bounds.

### 21. How do you defend against prompt injection?

I treat external content as data, not instructions. System rules and retrieved content stay clearly separated. Tools use allowlists, parameter validation, and least privilege. Sensitive actions go through a policy engine and human approval. I also check outputs for data leakage and unsafe actions. For indirect injection in documents or web pages, I tag the source and never let that content override system policy.

### 22. What do you do when the user’s intent is unclear or contains several goals?

First, I check whether any missing information is essential. If guessing would be risky, I ask one focused clarification question. If there’s a safe default, I state the assumption and continue. For multiple goals, I split them into tasks and show the plan. If goals conflict, I ask the user to prioritize. High-risk actions still require confirmation even if the intent seems clear.

### 23. How do you keep structured LLM output from breaking JSON parsing?

I prefer native structured output or JSON Schema. I restrict fields and enums, then validate everything on the server. If parsing fails, I can feed the validation error back for a limited repair attempt. I never rely only on the prompt for important business logic. The code still checks types, ranges, required fields, and cross-field rules.

### 24. How do you handle tool failures?

I first classify the error: transient, rate limit, permission, invalid parameter, or business failure. Transient failures get exponential backoff with jitter. Rate limits follow the server’s retry guidance. A parameter error may be corrected once using validation feedback. Permission and business errors should not be retried blindly. I can fall back to another tool, cached data, or a human process. Calls with side effects also need idempotency and compensation.

### 25. How do you prevent an agent from looping forever?

I set hard limits on steps, elapsed time, tokens, cost, and repeated tool calls. I track call signatures and output hashes to detect repetition. Every step should create measurable progress; otherwise, I trigger re-planning or stop. After repeated failures, I return what was completed, explain what failed, and suggest the next step instead of continuing to burn resources.

### 26. What if the tool succeeds but writing the result back fails?

I’d use an outbox-style design or record the request and idempotency key before calling the external system. If the write-back fails, the recovery process checks the external status using its transaction ID and then repairs local state. If the external system can’t be queried, I’d first put the result into a durable message or log so we don’t treat an unknown state as a failure and repeat the action.

### 27. How do you manage permissions, approvals, and audit for risky tools?

I classify tools by risk: read-only, write, financial, personal data, and so on. User identity maps to fine-grained permissions, and the agent receives only short-lived credentials for the current task. High-risk actions show the target, parameters, and impact before asking for confirmation. The audit record includes the user, model, prompt version, tool, parameter summary, result, and timestamp, with sensitive values masked.

### 28. Which layer should validate bad tool parameters?

All of them, but for different reasons. The model layer should produce schema-compliant arguments. The orchestration layer checks context, permissions, and policy. The tool layer must perform final validation because it can’t trust the caller. The closer we get to a real side effect, the stricter the checks should be.

---

## 3. Project Deep Dives

### 29. Give an example of how Task Space would break down and run a complex task.

Take “analyze an auto-finance product market and prepare a presentation.” I’d first clarify the market, time period, and audience. Then I’d split it into research, source validation, competitor comparison, calculations, insight writing, slide generation, and quality checks. Competitor research can run in parallel. The narrative comes after the evidence is ready. Every conclusion keeps its source, and the final step checks facts, layout, and missing information.

### 30. Is task planning done once, or does it change during execution?

I prefer an initial plan plus controlled re-planning. The agent creates an understandable high-level plan first, then adjusts unfinished tasks based on tool results, failures, or new information. Completed steps with side effects can’t simply be undone. Every plan change should have a reason and a version so the agent doesn’t keep changing direction without control.

### 31. How do you measure Task Space quality?

I measure it at several levels. At the step level: tool success, retry rate, and recovery success. At the task level: completion rate, human takeover rate, duration, and cost. At the result level: factual accuracy, evidence coverage, format compliance, and user rating. At the business level: time saved, reuse, and adoption. A single pass-or-fail metric is not enough for complex tasks.

### 32. How do you make sure research citations are real?

The search tool returns the URL, title, publication date, and relevant text. Each factual claim gets linked to an evidence ID. During generation, the model can only cite IDs that exist in the evidence store. After generation, I verify that the source exists, actually supports the claim, and is current enough. If the evidence is weak, the system should say so instead of inventing a link.

### 33. What if different sources disagree?

I compare authority, publication date, methodology, and original data. I prefer regulators, official company disclosures, and primary research. If the disagreement remains, I show both views and explain why they differ. I don’t force the agent to invent one certain answer when the evidence is genuinely uncertain.

### 34. How does natural language become an executable Skill?

I extract the goal, inputs, outputs, steps, dependencies, tools, permissions, and error policy, then convert that into a controlled workflow schema or DSL. The workflow is statically validated and tested in a sandbox before release. The LLM helps understand and draft the workflow, but the runtime only executes valid structured definitions, not arbitrary text.

### 35. How do you define a Skill’s inputs, outputs, permissions, and dependencies?

I’d use a machine-readable manifest with the name, version, input and output schemas, tool dependencies, timeouts, resource budget, permission scope, network access, data classification, and error codes. That lets the platform validate compatibility before runtime and supports audit and version upgrades.

### 36. How do you stop a user-generated Skill from running malicious code?

By default, I don’t allow arbitrary code. I prefer controlled workflow nodes and allowlisted tools. If code execution is necessary, it runs in an unprivileged sandbox with limits on the file system, network, CPU, memory, and time. I’d also add dependency scanning, static checks, dangerous API detection, approval for high-risk permissions, and signed versioned releases.

### 37. How do you keep old workflows working after a Skill upgrade?

I use semantic versioning and immutable releases. Existing workflows pin a specific version. New fields get safe defaults, while breaking changes require a major version. Contract tests and replay tests run before release. I also provide migration tools, gradual rollout, and rollback. Production workflows should never be silently switched to “latest.”

### 38. How is reusing a Skill different from reusing a prompt template?

A prompt template mainly reuses instructions for a model. A Skill is a complete executable and versioned capability with input and output contracts, tools, workflow steps, permissions, error handling, and evaluation. A Skill may contain several prompts, deterministic code, and even human approval steps.

### 39. Walk me through AI Mobile Card Generation from intent to delivery.

The user describes what they want. The system identifies the goal and required app capabilities, checks the device and capability registry, plans the actions and card layout, validates parameters and permissions, generates a preview, and publishes it to the home screen after confirmation. During execution, it records actual results and handles unavailable capabilities through a clear fallback or upgrade message.

### 40. Why did AI Mobile Cards need network-topology design?

Because the solution crosses the phone, cloud agent services, model services, capability gateways, and third-party apps. The topology determines traffic direction, authentication points, data boundaries, failure isolation, and release design. I needed to think through device-to-cloud protocols, gateways, service discovery, timeouts, retries, network segmentation, and where sensitive data was allowed to travel.

### 41. How would you authenticate the phone, cloud, and third-party apps?

The user authenticates on the phone, and the cloud receives a short-lived, scoped token. A capability gateway checks the user, device, app, and requested action. Third-party apps can use OAuth2/OIDC, signed requests, or platform-issued authorization tickets. Credentials should never be placed in prompts or long-term agent memory. High-risk actions still need explicit user confirmation.

### 42. How do you handle differences in app capabilities, versions, and permissions?

I’d maintain a versioned capability registry describing each app, action, parameter schema, minimum version, required permission, and fallback. The planner checks compatibility before planning, and the executor checks it again before the action. If something isn’t available, the system uses a compatible alternative, asks the user to upgrade, or explains the limitation instead of assuming the capability exists.

### 43. How do you trace and recover from a wrong card action?

Every generation and execution gets a request ID. I’d record the user intent, card version, model and prompt version, actual action, parameter summary, approval, and result. Reversible actions should support undo or compensation. Irreversible actions need preview and confirmation. If there’s an incident, I can disable the affected card version and trace whether the error came from intent, planning, parameters, or the app itself.

### 44. How do you turn deep research into a slide outline?

I start with the audience and the purpose, then organize the evidence into topics, supporting facts, and conclusions. From that, I create a slide-level outline with the purpose of each slide, title, key messages, chart ideas, and sources. I check logic, coverage, and repetition before generating any actual slides. That avoids building layout before the story is clear.

### 45. How do you prevent content from overflowing or mismatching the slide template?

I parse the template into a layout schema with capacity limits: title length, number of text blocks, chart slots, and image slots. The system selects a suitable layout before writing. After generation, it checks overflow and collisions. If needed, it shortens the text, splits the slide, or switches layouts. I wouldn’t rely on the model to guess the available space.

### 46. How do you evaluate an AI-generated presentation?

I’d look at factual accuracy, source quality, narrative flow, audience fit, readability, template consistency, and editability. Automated checks can detect broken citations, repetition, overflow, font size, and alignment. Business reviewers still need to score the presentation, ideally without knowing which version was AI-generated. I’d also track generation time, manual editing effort, and final adoption.

### 47. How would you generate a 50-slide deck while keeping it consistent?

I’d create a global outline, terminology list, visual theme, and fact base first. Then I’d generate one section at a time, giving each section only the relevant evidence plus a global summary. At the end, I’d run a cross-slide consistency pass for terminology, numbers, conclusions, repetition, and citations. I’d use structured state instead of putting all 50 slides into one context window.

---

## 4. Validating Resume Metrics

### 48. What was the baseline for the 40% throughput improvement?

I need to explain it with actual numbers. For example: under the same model, infrastructure, and workload, the system completed `[X]` tasks per minute before the change and `[Y]` after it, which was about a 40% improvement. The main changes were parallel task orchestration and dynamic load balancing. Before the interview, I need to fill in the verified environment, workload, X, and Y.

### 49. Did you measure QPS, concurrency, or completion time?

For long-running agent tasks, QPS alone is misleading. I’d use completed tasks per unit of time as the main throughput metric, together with end-to-end P50/P95 latency, concurrent tasks, success rate, and resource usage. If the original 40% used a different metric, I’d use the actual project definition rather than forcing it into QPS.

### 50. Were the test conditions the same before and after optimization?

They should be. I’d keep the model version, sampling parameters, machine type, dataset, concurrency pattern, and tool environment consistent. I’d warm up the system and repeat the test several times. If production conditions make perfect control impossible, I’d use traffic replay or a controlled A/B rollout and clearly say the result is an engineering observation rather than a laboratory experiment.

### 51. Where did the performance improvement mainly come from?

Based on the resume, the main gains came from parallelizing independent tasks and balancing work across execution nodes, which reduced serial waiting and hotspots. If caching, batching, or connection reuse also contributed, I should only mention them if they were actually used. Ideally, I’d show profiling data for each optimization instead of calling everything “architecture improvement.”

### 52. How many samples were behind the 92% intent accuracy?

That number isn’t in the resume, so I need to provide the real figures: `[please add sample count, number of classes, and time range]`. If I can’t access the exact number, I’d say it was the project’s acceptance metric and explain the evaluation method and limitations. I would not invent a sample size during the interview.

### 53. What does “recognized by customers” actually mean?

I’d make it concrete: PoC acceptance, production launch, active use, renewal, user score, or approval at a formal review. For each project, I should prepare `[project — current stage — evidence of feedback — next step]`. If it only received positive feedback in a demo, I’d say it passed a PoC review, not that it generated revenue.

### 54. Which projects did you lead, and which did you contribute to?

I’d answer with a clear RACI-style breakdown. For AI Mobile Cards, I was responsible for network topology, project coordination, delivery, and release. For the multi-agent platform, I was a core developer for cloud-side algorithm and engineering modules. For Task Space, VibeSkill, Xiaoyi Claw, and AIPPT, I need to state `[lead/core contributor/participant and exact module]`. The important thing is to separate my work from the team’s overall result.

---

## 5. LLM and RAG

### 55. Design an internal RAG assistant for Mercedes-Benz Financial Services.

I’d build a pipeline for document ingestion, parsing, cleaning, permission tagging, chunking, embeddings, and indexing. At query time, I’d use query understanding, permission filtering, hybrid retrieval, reranking, generation, and citation checks. Enterprise identity and document ACLs must apply at retrieval time. Every answer should show evidence, and the system should refuse when evidence is weak. The platform also needs versioning, evaluation, audit, monitoring, and an on-premise model gateway.

### 56. How would you chunk documents?

I wouldn’t use one strategy for everything. Policies and contracts should be split by heading, clause, and semantic boundary, while keeping the section path. Long sections can then be divided with controlled overlap. Tables should stay logically intact or be converted into structured text. I’d tune chunk size through retrieval evaluation, balancing context completeness against precision.

### 57. How do you choose and evaluate an embedding model?

I’d consider language coverage, financial terminology, context length, deployment options, latency, and license. Then I’d evaluate it on real Mercedes-Benz Financial Services query-document pairs using Recall@K, MRR, and nDCG. Chinese, English, abbreviations, product names, and regulatory terms need separate test slices. I’d choose the best domain result and operational fit, not simply the top public benchmark.

### 58. Compare vector search, keyword search, and hybrid search.

Vector search is good at semantic similarity but may miss exact product codes or clause numbers. Keyword search is strong for exact terms but weaker with paraphrases. Hybrid search combines both, often through score fusion or reciprocal rank fusion. For financial knowledge, I’d normally start with hybrid retrieval and then rerank the candidates.

### 59. What are Recall@K, Precision@K, MRR, and nDCG?

Recall@K measures how many relevant documents appear in the top K. Precision@K measures how many of those top K are actually relevant. MRR focuses on how early the first relevant result appears. nDCG considers both graded relevance and ranking position across several results. For RAG, I care about retrieval quality and separately evaluate answer faithfulness and citation support.

### 60. Where does a reranker fit, and what does it cost?

It sits after initial retrieval and before context assembly. The retriever may return dozens of candidates, and a cross-encoder or LLM reranker selects the best few. The trade-off is extra latency and compute, so I’d limit the candidate set, batch requests, cache results, and skip reranking for simple queries when appropriate.

### 61. How do you handle scanned documents, tables, contracts, and policy versions?

Scans go through OCR while preserving page and coordinate information. Tables are extracted structurally with headers. Contracts are split by clauses. Policies need effective date, expiry date, region, and version metadata. Retrieval filters by the business date and applicable scope, and the final answer shows the exact document version and page.

### 62. How do you make sure the answer only uses internal knowledge?

The prompt should say that clearly, but system controls matter more. I only give the model retrieved evidence. Important claims must reference evidence IDs. After generation, I run a support or entailment check. If the evidence doesn’t support the answer, the system refuses. For high-risk use cases, I’d use more extractive answers or fixed templates.

### 63. What should the assistant do when retrieval is weak?

I’d use thresholds based on relevance, evidence coverage, and post-generation validation. If the evidence is too weak, the assistant should say it couldn’t find enough internal support, explain what it searched, and suggest a narrower query, the right department, or a knowledge-gap request. A useful refusal should still help the user move forward.

### 64. How do you enforce department-level access control?

At ingestion, every document gets ACL, department, role, and sensitivity metadata from the source system. At query time, the user’s identity token becomes a server-side retrieval filter. For stronger isolation, I can use separate indexes; otherwise, strict metadata filtering may be enough. I never retrieve everything and try to remove sensitive content after generation. All retrieval and download actions are audited.

### 65. How do you deploy RAG in an environment with no public internet?

I’d run the generation model, embedding model, reranker, vector database, and object storage locally. Images and dependencies would come through an approved offline artifact repository. Data never leaves the controlled network. The system uses internal identity, gateways, and monitoring. I’d also plan GPU capacity and use quantization, batching, and caching where necessary.

---

## 6. From PoC to Production: AI Credit Review Assistant

### 66. How would you build a PoC in two weeks?

Days one and two: align with credit, compliance, and security on one narrow scenario and measurable success criteria. Days three to five: prepare anonymized samples, policy documents, and a baseline. Days six to nine: build document extraction, rule checks, RAG evidence, and risk summaries. Days ten and eleven: offline evaluation and red-team testing. The final days: demo, business validation, and a production-gap list. The PoC would support reviewers, not make approval decisions.

### 67. What is the minimum viable scope?

I’d limit it to one product, a few document types, and a small number of high-value risk checks. The output would be a structured document summary, missing items, policy references, risk flags, and questions for human review. I would not start with full system integration, automated decisions, or complex model training. Success means accuracy, traceable evidence, time saved, and user acceptance.

### 68. Where would you use rules, machine learning, RAG, and LLMs?

Hard eligibility thresholds belong in deterministic rules. A governed traditional ML model can estimate default risk from historical data. RAG provides current policy and product knowledge. LLMs help extract and summarize unstructured documents and explain findings. The existing decision system and authorized reviewers still make the final credit decision.

### 69. How do you stop the LLM from making an unauthorized credit decision?

I’d enforce that at several layers. The UI clearly says it is decision support. The output schema doesn’t include a final approval action. A policy engine blocks unauthorized writes. Every recommendation needs human confirmation. Final approval and credit-limit fields can only be written by authorized systems. The audit trail records both the AI recommendation and the human decision.

### 70. How would you design the human-review process?

The AI extracts facts and lists evidence, risks, and uncertainty. The reviewer confirms, edits, or rejects each item and gives a reason. Low-confidence cases and policy conflicts are escalated automatically. Only an authorized reviewer can submit the final decision. Human feedback can improve evaluation data, but it shouldn’t automatically retrain or change the production model without review.

### 71. How do you evaluate correctness, fairness, and explainability?

For correctness, I’d measure extraction accuracy, risk recall, citation support, and error severity. For fairness, I’d compare false positives, false negatives, and business impact across legally permitted groups, and check for proxy variables. For explainability, every recommendation should show the facts and the policy or rule behind it. Business, model risk, compliance, and legal teams should review the system before launch.

### 72. How do you protect personal and sensitive data?

I’d apply purpose limitation and data minimization. Data is encrypted in transit and at rest, logs are masked, and non-production uses anonymized or synthetic data. Access is restricted by job role and case. Retention and deletion periods are explicit. Before calling any model, I’d confirm the deployment region and data-processing agreement. Sensitive information must never go to an unauthorized external model.

### 73. What services would the production architecture need?

At minimum: API gateway, identity and access control, document parsing, rule service, knowledge retrieval, model gateway, workflow orchestration, human-review UI, case storage, audit storage, monitoring, version management, and CI/CD. Underneath that, we need container infrastructure, secrets management, object storage, messaging, backup, and disaster recovery.

### 74. How do you version the model, prompts, knowledge base, and rules?

Every request should be tied to a model version and parameters, prompt version, knowledge snapshot, retrieval configuration, and rule version. Artifacts are immutable and approved before release. Changes go through testing, offline evaluation, and gradual rollout. If there’s a problem, I can roll back to the exact previous combination and reproduce what the system saw at that time.

### 75. How do you evaluate, roll out, and roll back a new version?

First, I run a frozen regression set and security tests with clear gates against the baseline. Then I use shadow traffic so the new version processes real inputs without affecting users. After that, I roll it out to a small percentage and monitor quality, latency, cost, and manual-edit rate. The model and configuration can switch back quickly, and database changes stay backward-compatible.

### 76. How do you record which model, prompt, rules, and evidence produced a recommendation?

I’d create an immutable audit record with request ID, user, case, time, input summary, model and parameters, prompt hash, rule version, retrieval query, document versions, chunk IDs, tool calls, output, human edits, and final decision. Sensitive source text stays in a protected store, while the audit log keeps references and masked summaries.

### 77. How do you monitor hallucination, latency, cost, and adoption?

For hallucination, I’d track unsupported-claim rate, citation support, and categories of human correction. For latency, I’d split P50/P95 across parsing, retrieval, model, and tools. For cost, I’d aggregate tokens or GPU usage by model and use case. Business metrics include recommendation acceptance, manual edits, review time, and missed risks. Serious metric changes should trigger degradation or shutdown.

### 78. What changes if everything must run on-premise?

I’d choose models that can be hosted locally with a suitable license, then build an internal model gateway, GPU pool, and offline artifact pipeline. Documents, embeddings, and logs stay inside the controlled domain. External tools are replaced by internal services. If the local model is weaker, I’d narrow the task, strengthen RAG and rules, and rely more on human review rather than pretending the quality is the same.

---

## 7. Citi Financial-System Experience

### 79. What core problem did the liquidity risk platform solve?

It moved liquidity risk assessment, quality review, approval, issue tracking, and regulatory reporting from fragmented Excel and manual collaboration into one platform. That improved process consistency, traceability, efficiency, and data security. The platform’s main value was standardized workflow and evidence, rather than calculating every risk metric itself.

### 80. How would you model risk assessment, quality review, and approval?

I’d use a case or assessment as the aggregate root, with template version, data, status, owner, and audit history. A state machine or workflow defines steps, roles, conditions, returns, and escalation. Every submission creates an immutable version, while comments and issues are separate entities. Permissions consider role, region, legal entity, and task ownership.

### 81. What did the data model for the dynamic table engine look like?

I’d explain it in two layers: templates and instances. A template contains versions, sheets, rows and columns, data types, formulas, validation, permissions, and display settings. An instance stores the template version, cell values, calculated results, and workflow status. Formulas should reference stable field IDs rather than display coordinates. For reporting performance, we can add snapshots or wider read models, while keeping the source data normalized.

### 82. Did formulas run in the frontend or backend, and how did you keep them consistent?

The frontend can calculate immediately for a better user experience, but the backend must be the source of truth. Both sides should use the same formula DSL and parsing rules, or share the same calculation core where possible. The backend recalculates and validates on submission. For critical results, I’d store the formula version, inputs, and output. Regulatory calculations should never exist only in the browser.

### 83. How did the table engine support versioning, permissions, audit, and lineage?

Published templates were not edited in place; changes created a new version. Each data instance stayed linked to the template version it used. Roles controlled fields and actions. Every edit recorded the user, time, old value, new value, and reason. Approved data became read-only, and later corrections created a new version. Reports could be traced back to the source instance, cell, formula, and input data.

### 84. What are the core concepts in a lightweight workflow engine?

At minimum: process definitions and versions, nodes, transitions, conditions, tasks, instances, variables, participants, timers, events, state transitions, and audit records. In production, it also needs idempotency, retry, human tasks, return, withdrawal, and escalation. “Lightweight” means implementing the subset the business actually needs, not rebuilding an entire BPM product.

### 85. Why build a lightweight engine instead of keeping JBPM?

The honest answer depends on the actual project context. Our workflow patterns were relatively focused, while JBPM added licensing, maintenance, upgrade, and operational complexity. A smaller engine could cover the real approval and audit requirements with less dependency. But I’d also acknowledge the trade-off: custom software creates long-term maintenance risk, so it only makes sense when the scope is clear and the team can own it.

### 86. How did the reporting module replace MSTR?

We focused on the reporting capabilities the business actually used: datasets, queries, dimensions, measures, filters, permissions, templates, schedules, and exports. The backend generated parameterized queries or read pre-aggregated data, and longer exports ran asynchronously. The goal wasn’t to recreate every MSTR feature. It was to cover the high-value scenarios with access control, caching, scheduling, and auditability.

### 87. How was the USD 500K annual saving calculated?

I’d break it down into the MSTR and JBPM license, maintenance, infrastructure, and support costs that were removed, then subtract the ongoing cost of the in-house solution. Before the interview, I need the real `[finance-approved calculation, products, and license count]`. If USD 500K was a project estimate rather than an audited number, I’d say that clearly.

### 88. What does a production change look like in a regulated bank?

Typically it includes requirement and risk review, technical design, code review, automated tests, security and open-source scans, UAT, a formal change ticket, segregation-of-duties approvals, a release window, backup and rollback plans, production validation, and evidence retention. Emergency changes can move faster, but still need follow-up review and documentation. I’d describe Citi’s actual SDLC rather than claim every bank is identical.

### 89. How do you handle a production incident while staying audit-compliant?

First, contain the impact: confirm the alert, classify severity, roll back or isolate the issue. Then establish one incident lead and communication channel. Every action uses authorized accounts and is recorded in the incident or change ticket. After recovery, I verify data integrity, complete root-cause analysis, assign corrective actions, and retain the evidence. Urgency is not a reason to bypass access control.

### 90. How would you apply Citi’s governance experience to generative AI?

I’d extend the normal SDLC into an AI lifecycle. Besides code, I’d version models, prompts, knowledge, and evaluation sets. Before release, I’d evaluate quality, security, and bias. In production, I’d record evidence and human feedback. High-risk actions use segregation of duties. External models and open-source components go through license and security review. The same core ideas still apply: traceability, approval, rollback, and accountability.

---

## 8. Machine Learning and Research

### 91. Why did you choose nnU-Net?

nnU-Net is a strong medical-image segmentation baseline because it automatically adapts preprocessing, network configuration, training, and post-processing to the dataset. That’s useful when data is limited and imaging characteristics vary. It reduced arbitrary tuning and let me focus on improvements that were specific to orbital lymphoma and the downstream classification task.

### 92. How much data did you have, and how did you split it?

The resume doesn’t include those figures, so I need to provide the real `[number of patients, images or slides, and classes]`. The important point is that the split should be patient-level, not random image-level. I’d use training, validation, and an independent test set. With limited data, I can use cross-validation inside the training set, while keeping the final test set untouched.

### 93. How did you avoid putting data from the same patient in both training and testing?

I’d create a stable anonymized patient ID and use group-based splitting. Every image, augmentation, and time point from the same patient stays in the same partition. After splitting, I’d run duplicate and metadata checks so renamed files or derived samples don’t accidentally leak across datasets.

### 94. Which segmentation metrics did you use?

The main metrics are usually Dice and IoU for overlap. Precision and recall help show over- and under-segmentation, while Hausdorff distance can capture boundary quality. I’d also break results down by lesion size or subtype instead of only reporting one average. In the interview, I should name only the metrics actually used in my paper.

### 95. Is 87% classification accuracy good enough?

Accuracy alone isn’t enough. I’d look at class balance, sensitivity, specificity, AUC, confidence intervals, and comparison with the clinical or model baseline. In a medical setting, missing a high-risk case may matter much more than a false positive. So 87% can demonstrate research feasibility, but it does not mean the model is ready for direct clinical use.

### 96. Why use XGBoost instead of an end-to-end deep-learning classifier?

With limited data and meaningful structured spatial and texture features, XGBoost can be robust, interpretable, and relatively efficient. It also makes feature contribution easier to study. An end-to-end model may have a higher ceiling, but it generally needs more data and careful regularization. The right choice should come from a fair comparison on the same patient-level split.

### 97. What spatial and texture features did you use?

Spatial features can include location, area, volume, shape, axes, boundary characteristics, and left-versus-right relationships. Texture features can include gray-level co-occurrence statistics, local binary patterns, first-order statistics, and wavelet features. In the interview, I’d only list the features actually used in the paper and explain normalization and feature selection.

### 98. How did you handle class imbalance?

I’d use patient-level stratified splitting, class weights, controlled oversampling, or targeted augmentation. I’d tune the decision threshold based on the cost of each error. Evaluation should include macro F1, per-class recall, PR-AUC, and the confusion matrix. Oversampling must happen after the split; otherwise, similar samples can leak into the test set.

### 99. What exactly was your contribution to the two publications?

I’d answer using a contribution breakdown: problem definition, data preparation, method design, implementation, experiments, analysis, and writing. For example, “I owned `[please add actual contribution]`, while my co-authors handled `[please add actual contribution]`.” I should also be able to explain the main figures, tables, and ablation results so it’s clear I understand the work beyond authorship.

### 100. If you did the research again, what would you improve?

I’d expand to multi-center data and keep an external test set. I’d standardize annotation and measure agreement between annotators. I’d compare with end-to-end and self-supervised baselines, report confidence intervals and subgroup performance, and add calibration and interpretability. I’d also introduce data and model versioning from the start and evaluate how the system fits into a real clinical workflow.

---

## 9. Software Engineering and Production Readiness

### 101. Which parts of an AI system are better suited to Python, and which to Java?

Python is a natural fit for model inference, data processing, prompt and agent iteration, and the ML ecosystem. Java is strong for enterprise services with complex transactions, strong typing, high concurrency, and mature governance. A practical design is to use Python for AI capability services and Java for core business orchestration, permissions, and transactional systems, connected through stable APIs or messaging.

### 102. How would you design a scalable model gateway?

I’d provide unified chat, embedding, and reranking APIs, with adapters for cloud and local models. The gateway handles authentication, quotas, routing, rate limits, timeouts, retries, circuit breakers, streaming, caching, and content safety. It logs model version, tokens, latency, and cost. A policy layer chooses the model based on task, data sensitivity, quality, and price, with controlled fallback and rollout.

### 103. How do you rate-limit, time out, retry, and circuit-break LLM requests?

I’d use token buckets by user, application, and model. Connection timeout, time-to-first-token, and total timeout should be separate. I only retry recoverable failures such as network errors or rate limits, with exponential backoff. After a failure threshold, the circuit opens and traffic falls back to another model or a degraded path. With streaming, I’m careful about retrying because it can duplicate cost or side effects.

### 104. How do you make sure queued tasks are not lost or processed twice?

On the producer side, I’d use a transactional outbox or confirmed delivery. The broker uses persistence and replication. The consumer acknowledges only after the business transaction succeeds. A business key and deduplication table make the operation idempotent. In practice, “exactly once” usually means at-least-once delivery plus business-level idempotency.

### 105. What can Redis do in an agent platform?

Redis is useful for short-lived sessions, task-state caching, distributed locks, rate limits, idempotency keys, capability registration, and hot-result caching. I wouldn’t use it as the only long-term source of truth for critical tasks. Important state belongs in durable storage. Locks also need leases and ownership checks so one worker doesn’t release another worker’s lock.

### 106. How do you autoscale agent services in Kubernetes?

Stateless APIs can scale on concurrency, queue length, P95 latency, or custom task metrics. Long-running workers can scale based on pending work and estimated workload. GPU inference needs a dedicated node pool, model warm-up, and slower scale-down. Task state should live outside the Pod, and terminating Pods should stop accepting new work and save checkpoints before shutdown.

### 107. Why can’t you autoscale an LLM service based only on CPU?

The bottleneck is often GPU memory, KV cache, active sequences, token volume, or queue length, while CPU usage stays low. I’d monitor GPU utilization and memory, time to first token, generation speed, batch size, request length, and queue depth. Because model loading is slow, predictive scaling may also be necessary.

### 108. How do you design logs, metrics, and distributed tracing?

I’d use one trace ID across the entry point, planner, model calls, retrieval, and tools. Logs are structured and masked. Metrics cover traffic, errors, latency, saturation, tokens, cost, tool success, and task completion. Traces show the duration and version of every span. Model inputs and outputs are only stored when policy allows; otherwise, I keep masked summaries or hashes.

### 109. How do you manage API keys and model credentials?

They belong in an enterprise secrets manager. Workloads retrieve short-lived credentials through workload identity. Secrets never go into source code, images, prompts, or normal logs. Permissions are separated by service and environment, credentials are rotated, and usage is monitored. CI/CD passes references to secrets, not the plaintext values.

### 110. What do Sonar, Black Duck, and AppDynamics each do?

Sonar focuses on static code quality and defects. Black Duck identifies open-source components and checks licenses and known vulnerabilities. AppDynamics focuses on runtime application performance and transaction tracing. Together, they cover source code, software supply chain, and production behavior, but they don’t replace one another.

---

## 10. Behavioral and Technical Leadership

### 111. Tell me about a PoC that didn’t meet expectations.

I wouldn’t invent a failure. I’d choose a real case and use a simple structure: “The goal was `[goal]`, and our initial assumption was `[assumption]`. The validation showed `[quality, data, or integration problem]`. I narrowed the scope, added evaluation, and aligned with the business on whether to pivot or stop. That helped us avoid `[wasted cost or risk]`. The lesson was to define success metrics and exit criteria earlier.”

### 112. What do you do if the business wants a fast launch but security blocks it?

I turn the disagreement into specific risks and controls. I ask exactly what is blocking the launch, then propose a graded path: anonymized data, read-only tools, on-premise deployment, human approval, a small user group, or a time-limited sandbox. The risk owner and exit conditions are documented. I wouldn’t bypass security, but I also wouldn’t stop at “no”; I’d find the smallest safe experiment.

### 113. What if a product manager asks for an AI feature with no measurable value?

I’d ask who the user is, what the current process looks like, how often the pain occurs, and what the non-AI baseline is. Then I’d translate value into time saved, quality, conversion, risk, or experience. I’d define a two-week PoC and a stop condition. If nobody can explain the user or the decision the feature improves, I wouldn’t commit major engineering effort.

### 114. How would you explain hallucination to a non-technical executive?

I’d say an LLM is like a very fluent assistant that can sometimes sound confident even when it’s unsure. The solution isn’t to ask it to “never make mistakes.” We give it trusted evidence, require citations, limit what it can do, and have people review high-risk outcomes. Then I’d use a business example and actual error rates rather than only technical language.

### 115. Tell me about a technical disagreement.

A good real example is the decision between keeping JBPM and building a lightweight workflow engine. Different teams cared about speed, maintenance, licensing cost, and operational risk. I helped turn those opinions into measurable criteria, compared actual requirements with the product’s capabilities, and documented the trade-offs and migration plan. The goal is to show how I made the decision evidence-based, not to show that the other side was wrong.

### 116. How do you move a cross-functional project from demo to production?

Right after the demo, I create a production-gap list: business owner, data, compliance, security, architecture, SLA, evaluation, operations, and cost. I define RACI and milestones. The prototype is refactored into a versioned service, with a frozen evaluation set and release gates. Then I start with a small controlled rollout and use business metrics—not demo excitement—to decide whether to scale.

### 117. How do you prioritize several AI PoCs?

I score them on business value, feasibility, risk, data readiness, reuse potential, and delivery time. I prioritize high-value, lower-risk ideas with available data and reusable platform value. High-value regulated ideas may begin as controlled research. I also limit work in progress. Every PoC needs a business owner, success metric, and clear exit condition.

### 118. How would you establish prompt, evaluation, and agent-development standards?

Prompts need templates, variable schemas, owners, versions, and change history. Evaluation sets should cover normal, edge, safety, and regression cases, with frozen versions. Every tool needs an input/output contract, permissions, idempotency, and timeout. Releases require review, offline evaluation, red-team testing, gradual rollout, and rollback. Every call records the model, prompt, tools, and cost.

### 119. Which AI technologies have you studied recently, and how do you decide whether to adopt them?

My recent focus includes MCP, A2A, multi-agent systems, subagents, skills, channels, and long-running task orchestration. I judge adoption by whether it solves a real problem, improves quality over a baseline, fits latency and cost constraints, has a mature ecosystem, meets security requirements, supports private deployment, and has an acceptable migration cost. I test it with a small benchmark and PoC before production adoption.

### 120. What would you do in your first 90 days?

In the first 30 days, I’d learn the business, data, systems, and governance process, and talk to credit, customer service, operations, compliance, and IT. From days 31 to 60, I’d choose one high-value, lower-risk use case and deliver a measurable PoC with evaluation and safety baselines. From days 61 to 90, I’d run a controlled pilot and start building reusable capabilities such as a model gateway, RAG components, tool contracts, prompt versioning, and monitoring.

---

## 11. Additional English Practice Answers

### E1. Please introduce one AI agent project that you led from prototype to production.

One representative project was AI Mobile Card Generation for Huawei Xiaoyi. The goal was to translate a user’s natural-language intent into a customized shortcut card that orchestrates capabilities from mobile applications. I contributed to the agent workflow and was responsible for network-topology design, project coordination, delivery, and release. We first validated the intent-to-capability flow with a focused prototype, then added capability discovery, parameter validation, permission checks, preview, and cloud-native deployment. The project moved from solution validation to production delivery. I’d add the verified user or adoption metrics once confirmed.

### E2. How did you measure the 40% throughput improvement?

We compared completed agent tasks per unit of time before and after introducing parallel task orchestration and dynamic load balancing. The model version, infrastructure, workload distribution, and concurrency settings should stay consistent. I’d also monitor success rate and P95 latency so throughput doesn’t improve at the expense of quality. In the interview, I need to provide the actual baseline, optimized value, test duration, and environment: `[please add verified figures]`.

### E3. What are the major risks of deploying generative AI in financial services?

The main risks are hallucination, leakage of personal or confidential data, unauthorized actions, bias, weak explainability, model or prompt drift, third-party dependency, and poor auditability. I’d manage them with grounded evidence, deterministic rules for hard constraints, least-privilege access, human approval for high-risk decisions, full version and audit records, offline evaluation, red-team testing, gradual rollout, and rollback. An LLM should support—not independently make—regulated credit decisions.

### E4. How would you explain an AI agent architecture to a non-technical stakeholder?

I’d describe an agent as a digital coordinator. It understands the user’s goal, breaks it into steps, chooses approved tools, tracks progress, and assembles the result. Around it, we need guardrails: identity and permissions, trusted knowledge, human confirmation for risky actions, and a complete audit trail. Then I’d map each component to a real business step so the stakeholder can evaluate value and risk without needing to understand model internals.

### E5. Describe a technical disagreement with a global team and how you resolved it.

A relevant example is the choice between retaining a heavyweight workflow dependency and building a lightweight engine around our actual needs. Different teams were concerned about speed, long-term maintenance, licensing cost, and operational risk. I helped define measurable criteria, compare required capabilities with the existing product, and document the trade-offs and migration plan. We aligned on a scoped solution with testing, governance, and rollback. It reduced external dependency and contributed to annual cost savings.

### E6. How would you design an on-premise RAG solution for confidential financial documents?

I’d deploy document parsing, embeddings, a vector database, reranking, and the generation model inside the controlled network. Documents would be tagged with source-system permissions and version metadata during ingestion. At query time, enterprise identity becomes a server-side retrieval filter, followed by hybrid retrieval, reranking, and evidence-grounded generation. Every answer includes document and page references, and weak evidence triggers a refusal. The platform also needs encryption, audit logs, offline evaluation, versioning, monitoring, and an offline software-supply-chain process.

---

## Facts to Verify Before the Interview

1. The baseline, optimized result, test environment, and workload behind the 40% throughput improvement.
2. Sample count, number of classes, baseline, and evaluation method behind the 92%+ intent accuracy.
3. Your exact role, project stage, and evidence of customer recognition for every Huawei AI project.
4. The real architecture boundary, topology responsibilities, and release metrics for AI Mobile Cards.
5. The finance-approved calculation behind the USD 500K annual saving at Citi.
6. Patient count, image count, data split, metrics, and your contribution to the medical-AI research.
7. Titles, journals or conferences, author order, and public links for the two publications.

## Recommended Practice Order

1. Start with questions 1, 2, 7, 48, 55, 66, 79, 99, and 120. Keep each answer to two or three minutes.
2. Practice the agent follow-up sequence from 8 to 28 so the architecture stays consistent.
3. Whiteboard the RAG system and credit-review assistant from start to finish.
4. For every number on the resume, prepare the definition, baseline, action, result, and limitation.
5. Record yourself answering the six questions in Section 11. Aim for 60–90 seconds each.
