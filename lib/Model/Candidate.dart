



class Candidate
{
  String name = "dummy";
  String description = "dummy";
  int numberOfVote = 0;


  Candidate({this.name,this.description =''});


  Map<String, dynamic> toJson() =>
  {
    'numberOfVote'  : numberOfVote,
    'name'          : name,
    'description'   : description
  };

   Candidate fromJson ( Map<String, dynamic> json)
  {
    numberOfVote  = json['numberOfVote'] as int;
    name = json['name'] as String;
    description = json['description'] as String;
    return this;
  }

}
