class CreateChallengeTool < RubyLLM::Tool
  # This teels the LLM when to use the tool
  description "Use this tool when you are asked to create a challenge. After creation, provide a link to that challenge as a markdown using ONLY a relative path — no domain, no scheme (do not prepend http://, https://, or any hostname). Example: [Challenge Name](/challenges/42)"
  # these are the attributes the tool needs in order to run the code
  param :name, desc: "This is the name of the challenge."
  param :module_name, desc: "This is the module the challenge belongs to (eg. Ruby, OOP, Rails, Front-end)"
  param :instructions, desc: <<~TXT
    This is the instructions for the challenge.
    You should create a custom challenge, based on the request. It should be written in Markdown. It should be broken into multiple sections: Background & Objectives, Specs, and Further Learning.
    Here is an example of how other challenges are formatted:
    ## Background & Objectives

    Let us keep practicing blocks in this challenge. We will code another method that should be called with a block, and this time we will see how blocks enable nesting method calls, and how this can be useful in a real-life example. We will also discover how we can define methods with a second optional parameter, which happens frequently!

    ## Specs

    Implement the #tag method that builds the HTML tags around the content we give it in the block. For instance:
    ```ruby
    tag("h1") do
      "Some Title"
    end
    #=> "<h1>Some Title</h1>"
    ```

    This method accepts a second optional parameter (see section below on arguments with default value), enabling to pass an array with one HTML attribute name and its value, like ["href", "www.google.com"].
    ```ruby
    tag("a", ["href", "www.google.com"]) do
      "Google it"
    end
    #=> '<a href="www.google.com">Google it</a>'
    ```

    You may need to know that to include a " symbol inside a string delimited by double quotes,
    you need to escape this character with an antislash: \".

    The cool thing about this method is that you can nest method calls:

    ```ruby
    tag("a", ["href", "www.google.com"]) do
      tag("h1") do
        "Google it"
      end
    end
    # => '<a href="www.google.com"><h1>Google it</h1></a>'
    ```

    Cool right?
    Arguments with default value

    In Ruby you can supply a default value for an argument. This means that if a value for the argument is not supplied, the default value will be used instead, e.g.:

    ```ruby
    def sum(a, b, c = 0)
      return a + b + c
    end

    sum(3, 6, 1) # => 10
    sum(4, 2)    # => 6
    ```

    Here, the third argument is worth 0 if we call sum with only two arguments.
  TXT

  # The llm will ask our application to run this method and provide the parameters for it
  def execute(name:, module_name:, instructions:)
    # the actual work
    challenge = Challenge.new(
      name: name,
      module: module_name,
      content: instructions
    )
    if challenge.save
      # tell the ai that we made a new challenge and provide the challenge info for the llm to create the final response
      { success: true, challenge_id: challenge.id}
    else
      # tell the ai what went wrong
      { success: false, errors: challege.errors.full_messages}
    end 
  end
end
