-- ============================================================
-- HelpDesk Ticket Analysis
-- Dataset: customer_support_analysis
-- Description: Exploratory and analytical queries examining
--              agent performance, ticket distribution, and
--              customer satisfaction patterns.
-- ============================================================

-- Switch to the appropriate database
USE customer_support_analysis;


-- Exploratory Questions

/*
	Q1. What is the ID of the agent who has handled the most number of tickets?
*/	-- The agent with the agent_id = 16 has handled the most number of tickets (36).

SELECT agent_id, COUNT(*) AS ticket_count
FROM tickets
GROUP BY agent_id
ORDER BY ticket_count DESC;

/*
	Q2. How many agents haven't handled any tickets?
*/ -- All agents have handled tickets.

SELECT COUNT(*) AS agents_without_tickets
FROM agents a
WHERE NOT EXISTS (
    SELECT 1
    FROM tickets t
    WHERE t.agent_id = a.agent_id
);

-- Confirmation that counts for agents and distinct agent_id's on the tickets table is the same.

SELECT COUNT(*) FROM agents;
SELECT COUNT(DISTINCT agent_id) FROM tickets;

/*
	Q3. Retrieve the ID of the agent with the lowest number of tickets handled.
*/ -- Agents 41 and 14 are tied for lowest number of tickets handled (11 each).

SELECT agent_id, COUNT(*) AS ticket_count
FROM tickets
GROUP BY agent_id
ORDER BY ticket_count ASC;

/*
	Q4. How many customers have given a satisfaction score below 3?
*/ -- 131 customers gave at least one satisfaction score below 3. This is out of 300 total customers.

SELECT COUNT(DISTINCT customer_id) AS customers_below_3
FROM tickets
WHERE satisfaction_score < 3;


-- Counting how many customers are in total.

SELECT COUNT(*) FROM customers;


/*
	Q5. Which agent ID has the highest average satisfaction score?
*/-- Agents with agent_id 21 and 4 are tied for the highest average satisfaction score with a value of 4.

SELECT 
    agent_id,
    AVG(satisfaction_score) AS avg_score,
    COUNT(satisfaction_score) AS number_of_ratings
FROM tickets
GROUP BY agent_id
ORDER BY avg_score DESC;

/*
	Q6. What is the email of the customer who raised ticket_id 104?
*/-- barbara.sanders@email.com

SELECT c.email
FROM tickets t
JOIN customers c 
    ON t.customer_id = c.customer_id
WHERE t.ticket_id = 104;

/*
	Q7. What is the name of the agent assigned to ticket_id 110?
*/-- Gary Murphy.

SELECT a.name
FROM tickets t
JOIN agents a 
    ON t.agent_id = a.agent_id
WHERE t.ticket_id = 110;

/*
	Q8. What is the name of the customer who raised the highest number of tickets?
*/-- David Chavez is the customer who has raised the highest number of tickets (11).

SELECT c.name, COUNT(*) AS ticket_count
FROM tickets t
JOIN customers c
    ON t.customer_id = c.customer_id
GROUP BY t.customer_id
ORDER BY ticket_count DESC;

/*
	Q9. Which agent_id has the lowest % of resolved tickets?
*/-- Both agent_id 17 and 28 have 0% of resolved tickets, tying for the lowest.

SELECT 
    agent_id,
    100*SUM(status = 'resolved') / COUNT(*) AS resolved_percentage
FROM tickets
GROUP BY agent_id
ORDER BY resolved_percentage ASC;

/*
	Q10. What is the ID of the 7th ticket created by the customer with ID 61?
*/-- 308 is the ID of the 7th ticket created by the customer with ID 61.

SELECT 
    ROW_NUMBER() OVER (ORDER BY created_at) AS ticket_order,
    ticket_id,
    customer_id,
    created_at
FROM tickets
WHERE customer_id = 61;



-- Analytical Questions

/*
	Q11. How many agents have an average satisfaction score higher than the global average satisfaction score across all tickets?
*/-- 26 agents have an average satisfaction score higher than the global average satisfaction score across all tickets.

SELECT
    agent_id,
    AVG(satisfaction_score) AS agent_avg_score,
    (SELECT AVG(satisfaction_score) FROM tickets) AS global_avg,
    COUNT(*) OVER () AS agents_above_global_avg
FROM tickets
GROUP BY agent_id
HAVING agent_avg_score > global_avg;

/*
	Q12. How many customers have an average satisfaction score lower than the global average satisfaction score?
*/-- 136 customers have an average satisfaction score lower than the global average satisfaction score.

SELECT
    customer_id,
    AVG(satisfaction_score) AS customer_avg,
    (SELECT AVG(satisfaction_score) FROM tickets) AS global_avg,
    COUNT(*) OVER () AS customers_below_global_avg
FROM tickets
GROUP BY customer_id
HAVING customer_avg < global_avg;

/*
	Q13. What is the average satisfaction score of the last tickets raised by each customer?
*/-- 3.2 is the average satisfaction score of the last tickets raised by each customer.

WITH ranked_tickets AS (
    SELECT
        customer_id,
        satisfaction_score,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY created_at DESC
        ) AS rn
    FROM tickets
)
SELECT AVG(satisfaction_score)
FROM ranked_tickets
WHERE rn = 1;

/*
	Q14. For agent_id 33, what was the maximum number of tickets resolved in a month?
*/-- 2 tickets is the maximum number of tickets resolved in a month for agent_id 33.

SELECT
    YEAR(resolved_at) AS year,
    MONTH(resolved_at) AS month,
    COUNT(*) AS resolved_tickets
FROM tickets
WHERE agent_id = 33
  AND status = 'resolved'
GROUP BY YEAR(resolved_at), MONTH(resolved_at)
ORDER BY resolved_tickets DESC;

/*
	Q15.  What is the average satisfaction score of the most recently resolved ticket for each agent, only including agents who have resolved at least 5 tickets?
*/-- 3.5714 is the average satisfaction score of the most recently resolved ticket for each agent, only including agents who have resolved at least 5 tickets.

SELECT AVG(satisfaction_score)
FROM (
    SELECT
        agent_id,
        satisfaction_score,
        ROW_NUMBER() OVER (
            PARTITION BY agent_id
            ORDER BY resolved_at DESC
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY agent_id
        ) AS resolved_count
    FROM tickets
    WHERE status = 'resolved'
) t
WHERE rn = 1
AND resolved_count >= 5;