function MajorRequirements({ semesters, coursesData, majorRequirements }) {
  function normalizeCourse(course) {
    return course
      ? course.toUpperCase().replaceAll("-", "").replaceAll(" ", "")
      : "";
  }

  const checkedSemesters = semesters || [];
  const hasCheckedPlan = Boolean(semesters);

  const plannedCourses = new Set(
    checkedSemesters
      .flatMap((semester) => semester.courses)
      .filter(Boolean)
      .map(normalizeCourse),
  );

  const courseMap = {};
  for (const course of coursesData.courses) {
    courseMap[normalizeCourse(course.code)] = course;
    courseMap[normalizeCourse(course.id)] = course;
  }

  function getCompletedCourses(block) {
    return block.courseCodes.filter((course) =>
      plannedCourses.has(normalizeCourse(course)),
    );
  }

  function getBlockStatus(block) {
    const completedCourses = getCompletedCourses(block);
    const completedCredits = completedCourses.reduce((total, code) => {
      return total + (courseMap[normalizeCourse(code)]?.credits || 0);
    }, 0);

    if (block.code === "ANTH_FOUR_FIELDS") {
      const usedSubfields = new Set();
      const usedCourses = [];

      for (const code of plannedCourses) {
        const course = courseMap[code];
        const number = getCourseNumber(code);
        if (!course || !code.startsWith("ANT") || number < 200) continue;

        for (const subfield of course.subfields || []) {
          usedSubfields.add(subfield);
        }

        if (course.subfields?.length) {
          usedCourses.push(code);
        }
      }

      return {
        completed: usedSubfields.size >= 3,
        completedCourses: usedCourses,
        completedCredits: usedCourses.length * 4,
        detail: `${usedSubfields.size} / 3 subfields`,
      };
    }

    if (block.code === "ANTH_ADV_PATH_B") {
      const hasThesis = plannedCourses.has("ANT499");
      const advancedCourses = Array.from(plannedCourses).filter((code) => {
        return code.startsWith("ANT") && getCourseNumber(code) >= 300;
      });

      return {
        completed: hasThesis && advancedCourses.length >= 1,
        completedCourses: [
          ...advancedCourses,
          ...(hasThesis ? ["ANT499"] : []),
        ],
        completedCredits: advancedCourses.length * 4 + (hasThesis ? 4 : 0),
      };
    }

    if (block.code === "CSC_ELECTIVE") {
      const requiredCodes = getUsedRequiredCourses();
      const usedElectives = [];
      let completedCredits = 0;

      for (const code of plannedCourses) {
        const course = courseMap[code];
        if (!course || !code.startsWith("CSC")) continue;
        if (requiredCodes.has(code)) continue;
        if (["CSC281", "CSC282"].includes(code)) continue;
        if (getCourseNumber(code) < 200) continue;

        const credits =
          code === "CSC326" ? Math.min(course.credits || 0, 2) : course.credits || 0;
        completedCredits += credits;
        usedElectives.push(code);
      }

      const systemsTaken = ["CSC211", "CSC213"].filter((code) =>
        plannedCourses.has(code),
      );
      if (systemsTaken.length === 2) {
        const extraSystemsCourse = systemsTaken.find(
          (code) => !usedElectives.includes(code),
        );
        if (extraSystemsCourse) {
          completedCredits += courseMap[extraSystemsCourse]?.credits || 0;
          usedElectives.push(extraSystemsCourse);
        }
      }

      return {
        completed: completedCredits >= (block.minCredits || 4),
        completedCourses: usedElectives,
        completedCredits,
        detail: `${completedCredits} / ${block.minCredits || 4} credits`,
      };
    }

    if (block.code === "CSC_MATH_ELECTIVE") {
      const usedMathCourses = Array.from(plannedCourses).filter((code) => {
        if (code.startsWith("MAT") && getCourseNumber(code) > 131) return true;
        if (code.startsWith("STA")) return true;
        return false;
      });

      return {
        completed: usedMathCourses.length >= 1,
        completedCourses: usedMathCourses,
        completedCredits: usedMathCourses.reduce(
          (total, code) => total + (courseMap[code]?.credits || 0),
          0,
        ),
      };
    }

    if (block.code === "CSC_TOTALS_AND_POLICIES") {
      const usedCourses = Array.from(plannedCourses).filter((code) => {
        if (code.startsWith("CSC") && getCourseNumber(code) >= 151) return true;
        if (["MAT208", "MAT218"].includes(code)) return true;
        return false;
      });
      const completedCredits = usedCourses.reduce(
        (total, code) => total + (courseMap[code]?.credits || 0),
        0,
      );

      return {
        completed: completedCredits >= (block.minCredits || 32),
        completedCourses: usedCourses,
        completedCredits,
        detail: `${completedCredits} / ${block.minCredits || 32} credits`,
      };
    }

    if (block.ruleType === "must_take") {
      return {
        completed:
          block.courseCodes.length > 0 &&
          completedCourses.length === block.courseCodes.length,
        completedCourses,
        completedCredits,
      };
    }

    if (block.ruleType === "choose_one") {
      return {
        completed: completedCourses.length >= 1,
        completedCourses,
        completedCredits,
      };
    }

    if (block.ruleType === "choose_n") {
      return {
        completed: completedCourses.length >= (block.minCount || 1),
        completedCourses,
        completedCredits,
      };
    }

    if (block.ruleType === "choose_credits") {
      return {
        completed: completedCredits >= (block.minCredits || 0),
        completedCourses,
        completedCredits,
      };
    }

    return {
      completed: false,
      completedCourses,
      completedCredits,
    };
  }

  function getRuleLabel(block) {
    if (block.ruleType === "must_take") return "Required";
    if (block.ruleType === "choose_one") return "Choose 1";
    if (block.ruleType === "choose_n") return `Choose ${block.minCount || 1}`;
    if (block.ruleType === "choose_credits") {
      return `Choose ${block.minCredits || 0} credits`;
    }
    if (block.ruleType === "or_group") return "Choose one path";
    return "Custom rule";
  }

  function getCourseLabel(code) {
    const course = courseMap[normalizeCourse(code)];
    return course ? `${course.id}: ${course.name}` : code;
  }

  function getCourseNumber(code) {
    const match = normalizeCourse(code).match(/\d+/);
    return match ? parseInt(match[0], 10) : 0;
  }

  function getUsedRequiredCourses() {
    const used = new Set();

    for (const block of majorRequirements.blocks) {
      if (block.code === "CSC_ELECTIVE") continue;
      if (!["must_take", "choose_one", "choose_n"].includes(block.ruleType)) {
        continue;
      }

      if (block.ruleType === "must_take") {
        for (const code of block.courseCodes) {
          const normalized = normalizeCourse(code);
          if (plannedCourses.has(normalized)) used.add(normalized);
        }
      }

      if (block.ruleType === "choose_one") {
        const chosen = block.courseCodes
          .map(normalizeCourse)
          .find((code) => plannedCourses.has(code));
        if (chosen) used.add(chosen);
      }

      if (block.ruleType === "choose_n") {
        for (const code of block.courseCodes.map(normalizeCourse)) {
          if (plannedCourses.has(code)) used.add(code);
        }
      }
    }

    return used;
  }

  return (
    <div style={{ marginTop: "40px", color: "black" }}>
      <h2 style={{ color: "black" }}>
        {majorRequirements.major.name} Major Requirements
      </h2>
      <p>{majorRequirements.major.description}</p>

      {!hasCheckedPlan && (
        <div
          style={{
            marginTop: "20px",
            padding: "12px 16px",
            borderRadius: "8px",
            backgroundColor: "#eef2ff",
            border: "1px solid #c7d2fe",
          }}
        >
          Add or update courses, then click Check Requirements to refresh these
          results.
        </div>
      )}

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(2, minmax(0, 1fr))",
          gap: "16px",
          marginTop: "20px",
          textAlign: "left",
        }}
      >
        {majorRequirements.blocks.map((block) => {
          const status = getBlockStatus(block);
          const canAutoCheck = [
            "must_take",
            "choose_one",
            "choose_n",
            "choose_credits",
          ].includes(block.ruleType) ||
            [
              "ANTH_FOUR_FIELDS",
              "ANTH_ADV_PATH_B",
              "CSC_ELECTIVE",
              "CSC_MATH_ELECTIVE",
              "CSC_TOTALS_AND_POLICIES",
            ].includes(block.code);
          const completed = canAutoCheck && status.completed;

          return (
            <div
              key={block.code}
              style={{
                border: "2px solid #cc0033",
                borderRadius: "10px",
                padding: "16px",
                backgroundColor: completed ? "#d4edda" : "#f8d7da",
              }}
            >
              <h3 style={{ marginTop: 0 }}>{block.title}</h3>
              <p>
                <strong>Rule:</strong> {getRuleLabel(block)}
              </p>

              {block.courseCodes.length > 0 && (
                <ul>
                  {block.courseCodes.map((course) => (
                    <li key={course}>{getCourseLabel(course)}</li>
                  ))}
                </ul>
              )}

              {block.notes && <p>{block.notes}</p>}

              <p>
                <strong>Status:</strong>{" "}
                {canAutoCheck
                  ? completed
                    ? "Completed"
                    : "Not completed"
                  : "Review notes"}
              </p>

              {status.completedCourses.length > 0 && (
                <p>
                  <strong>Used:</strong> {status.completedCourses.join(", ")}
                </p>
              )}

              {block.ruleType === "choose_credits" && (
                <p>
                  <strong>Credits:</strong> {status.completedCredits} /{" "}
                  {block.minCredits || 0}
                </p>
              )}

              {status.detail && (
                <p>
                  <strong>Progress:</strong> {status.detail}
                </p>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

export default MajorRequirements;
