# CancerIQ Coding Challenge
This challenge allows you to work on some of the problems that we had to solve for a few of our current product offerings. It is split into three parts, of which we'd like you to complete one.

You have been assigned the backend challenge (2).

Frontend, the application's user interface
Backend, the application's data-processing component
Algorithms, the more purely mathematical aspect of the application
Scenario
CancerIQ's software, among other things, calculates the cancer risk for patients based on their medical history and the medical histories of their family members. If the patient's history shows that they are at elevated risk, they may be eligible for genetic testing (by sending a sample of their DNA to a laboratory).

Our software includes questionnaires that patients fill out about their medical history and the medical histories of their family members. The software also implements algorithms described in papers and other documents written by medical researchers. We then apply the algorithms, called "risk models" or "guidelines", to the history captured by the questionnaires. If the patient meets the criteria of the risk model, we alert their provider that they may qualify for testing.

Your challenge is to write part of a small application to calculate and display data about a patient's risk. Imagine that two other engineers are working on the project as well, each implementing one of the other components of the challenge.

## Backend Challenge
The backend service is responsible for taking data provided by the frontend and performing the risk calculations. The algorithm is spelled out at a high level in /article/smith_syndrome.md and is loosely inspired by the actual guidelines published by the National Comprehensive Cancer Network (NCCN).

You are not expected to implement the final criterion (“A close relative meeting any of the above criteria.”). This is part of the Algorithms challenge.

We provided schemas in /schemas. /schemas/input_schema.json represents the patient’s data, as provided by the frontend, and /schemas/output_schema.json represents the results of the risk analysis.

You may modify the application in any way the environment allows as long as the included specs pass. Check docs/environment.md for the gems that are available in the environment.

We have removed ActiveRecord, as it isn't necessary for this challenge, but you may add it back if you so choose (though you may find you can't generate migrations!). A PostgreSQL 13 service is available on postgresql://postgres@localhost/postgres and sqlite3 is configured by default.

## Criteria
We will evaluate your solution on three criteria:

Correctness. You should be confident that your code correctly implements the risk analysis algorithm. After all, health decisions could be made based on this code's output. The included specs test the given examples, but you'll find that they are not exhaustive.
Simplicity. This is important for two reasons. First, if bugs are found in the system, it needs to be easy to understand and modify. Second, new guidelines come out as time goes on, so the program needs to be able to adapt to them. The easier it is to understand, the easier it is to change in the future.
Integration. Your code needs to accept and produce data following the schemas provided. If any special conditions apply, you should document appropriately.
Additional Considerations
Once you've read through the instructions and the testing criteria you may have a few questions. For clarification and consideration:

Do we know anything about age of diagnosis even if it's not specified?
For the purposes of this exercise you can assume that a cancer type embodies all cancers of that type. For example, breast, represents all types of breast cancers.
Terminology
We threw in a small amount of medical jargon to give a sense of what it's like to work in our domain---terms like "first-degree relative" and "metachronous cancer." They should be easily Google-able, but you'll find some definitions here:

Male breast cancer: Simply the occurrence of breast cancer in a male.
First-degree relative: A first-degree relative is a person's parent, full sibling or child. 50% of the person's genes are shared with this relative.
Second-degree relative: Includes uncles, aunts, nephews, nieces, grandparents, grandchildren, half-siblings, and double cousins. 25% of a person's genes are shared with this relative.
Third-degree relative: Includes first cousins, great grandparents and great grandchildren. Approximately 12.5% of a person's genes are shared with this relative.
Synchronous cancer: A second primary cancer diagnosed within 6 months of the diagnosis of the first primary cancer.
Metachronous cancer: A second primary cancer diagnosed more than 6 months of the diagnosis of the first primary cancer.

## Example
Consider the example file spec/fixtures/input/patient_02.json:
```
{
    "id": "abc123",
    "firstName": "John",
    "lastName": "CancerIQ",
    "birthSex": "male",
    "dateOfBirth": "1950-03-25",
    "cancers": [{
        "cancerType": "brain",
        "ageOfDiagnosis": 54
    }],
    "motherId": null,
    "fatherId": null
}
```
The first set of criteria require the patient to have a Smith Syndrome cancer, defined in the footnote. Here, the patient has brain cancer, which counts. It was also diagnosed before the age of 60, so this person meets the first criterion. We continue to see if there are any other reasons this patient qualifies.

The person doesn't have two cancers, so the second criterion is out. The patient no relatives, so the fourth criterion is out. Now we encounter the criteria that apply if the person does not have cancer, so this entire set is out.

If you're reading this skeptically, this might bring up an issue of interpretation: wouldn't it be more conservative to include these criteria regardless of the patient's cancer status---after all, if it's dangerous to have relatives with cancer when the patient doesn't have cancer, isn't it even more dangerous if the patient has cancer? If you run into implementation questions like this, make a note of them in the README (if and only if you're completely blocked in you implementation, feel free to reach out for clarification). In this particular case, you can safely ignore those criteria if the patient doesn't have cancer; this is an artifact of the coding challenge (which is based on real criteria, but with things left out or moved around). The real risk models raise interpretive questions like this, too, but fortunately we can get in touch with subject-matter experts when we get stuck.

In any case, the correct output (as shown in spec/fixtures/output/patient_02.json) is:
```
{
    "meetsCriteria": true,
    "reasons": ["An individual with a Smith Syndrome cancer diagnosed at or before age 60"]
}
```
## Dependencies
Since you are not responsible for the frontend data collection or the computations needed to check criteria for the patient's family members, you can mock these components. Just make sure to document how the the (fictional) engineers building the front-end and algorithmic components would hook up their code to yours.

This may be more difficult in evaluating family members, but try to at least describe an interface that your code could use to evaluate the same risk criteria on family members. Would your code call another service or program to filter family members by criteria and return matching IDs? Maybe it would better for that code to call your risk analysis code and aggregate the results?

Whatever you decide, make sure to document it well and design your code with integration in mind.
