# This file runs a ranked choice algorithm.
# For decision making.
# Tally votes beforehand.
import copy

candidates: list[str] = []
num_voters: int = int(input("How many voters? "))
votes: list[list[int]] = []
candidate_tallies: list[int] = []

while True:
    new_candidate: str = input("Enter a candidate (or leave empty for no more): ")
    if new_candidate == "":
        break
    candidates.append(new_candidate)

for i in range(num_voters):
    print(f"Begin votes for voter {i + 1}")
    this_votes: list[int] = []
    for candidate in candidates:
        vote: int = len(candidates) - int(input(f"Rank for {candidate}: ")) + 1
        this_votes.append(vote)
    votes.append(this_votes)

while True:
    candidate_tallies = []
    for i in range(len(candidates)):
        candidate_tallies.append(0)
    for i in range(num_voters):
        this_votes: list[int] = votes[i]
        for j in range(len(this_votes)):
            candidate_tallies[j] += this_votes[j]
    least: int = round(9999)
    least_ind: int = 0
    most: int = round(-9999)
    most_ind: int = 0
    for i in range(len(candidate_tallies)):
        this_tally: int = candidate_tallies[i]
        if this_tally < least:
            least = this_tally
            least_ind = i
        if this_tally > most:
            most = this_tally
            most_ind = i
    for i in range(len(candidate_tallies)):
        if candidate_tallies[i] == least and i != least_ind:
            print("A tie was found when selecting a loser. Result may be invalid. Check manually.")
    print(f"Round results: {candidates} {candidate_tallies}")
    removed_top = copy.copy(candidate_tallies)
    removed_top.pop(most_ind)
    if most > sum(removed_top):
        print(f"Winner found! {candidates[most_ind]}")
        break
    candidates.pop(least_ind)
    candidate_tallies.pop(least_ind)
    for i in range(len(votes)):
        rank: int = votes[i].pop(least_ind)
        for j in range(len(votes[i])):
            if votes[i][j] < rank:
                votes[i][j] += 1

print(f"Round results: {candidates} {candidate_tallies}")