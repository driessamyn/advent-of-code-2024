SELECT SUM(COALESCE(sim.count, 0)*loc.a) FROM locations as loc
    LEFT JOIN (SELECT b, COUNT(*) as count FROM locations GROUP BY b) AS sim
    ON loc.a = sim.b;
