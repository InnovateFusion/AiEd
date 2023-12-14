import { NextFunction, Request, Response } from "express";
import addParticipantToContest from "../../application/use_cases/contest/addParticipant";
import addProblemToContest from "../../application/use_cases/contest/addProblem";
import createContest from "../../application/use_cases/contest/create";
import removeContest from "../../application/use_cases/contest/delete";
import findById from "../../application/use_cases/contest/findById";
import getContestInfo from "../../application/use_cases/contest/getContestInfo";
import getContesCreator from "../../application/use_cases/contest/getCreator";
import getContestParticipant from "../../application/use_cases/contest/getParticipants";
import getContestProblems from "../../application/use_cases/contest/getProblems";
import removeParticipantToContest from "../../application/use_cases/contest/removeParticipant";
import removeProblemToContest from "../../application/use_cases/contest/removeProblem";
import updateContest from "../../application/use_cases/contest/update";
import viewAllContest from "../../application/use_cases/contest/views";
import { IContestRepository } from "../../domain/repositories/contest";
import { IContestRepositoryImpl } from "../../infrastructure/repositories/contest";

export default function ContestController(
  contestRepository: IContestRepository,
  contestDbRepository: IContestRepositoryImpl
) {
  const dbRepository = contestRepository(contestDbRepository());

  const fetchContestById = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    findById(req.params.id, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  };

  const fetchAllContests = (
    req: Request,
    res: Response,
    next: NextFunction
  ): void => {
    const { skip = "0", limit = "10", search, sort } = req.query;

    const options = {
      skip: parseInt(typeof skip === "string" ? skip : "0", 10),
      limit: parseInt(typeof limit === "string" ? limit : "10", 10),
      search: search as string,
      sort: typeof sort === "string" ? parseSortParameter(sort) : undefined,
    };

    viewAllContest(options, dbRepository)
      .then((contests) => res.json(contests))
      .catch((error) => next(error));
  };

  const parseSortParameter = (
    sort: string | undefined
  ): Record<string, 1 | -1> => {
    if (sort) {
      const [field, order] = sort.split(":");
      const sortOrder = order === "desc" ? -1 : 1;

      return { [field]: sortOrder };
    }

    return { createdAt: 1 };
  };

  const createNewContest = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    createContest(req.body, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  };

  const updateExistingContest = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    updateContest(req.params.id, req.body, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  };

  const deleteContest = (req: Request, res: Response, next: NextFunction) => {
    removeContest(req.params.id, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  };

  const addProblem = (req: Request, res: Response, next: NextFunction) => {
    addProblemToContest(req.params.id, req.params.problemId, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const removeProblem = (req: Request, res: Response, next: NextFunction) => {
    removeProblemToContest(req.params.id, req.params.problemId, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const addParticipant = (req: Request, res: Response, next: NextFunction) => {
    addParticipantToContest(req.params.id, req.params.participantId, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const removeParticipant = (req: Request, res: Response, next: NextFunction) => {
    removeParticipantToContest(req.params.id, req.params.participantId, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const fetchParticipants = (req: Request, res: Response, next: NextFunction) => {
    getContestParticipant(req.params.id, req.query, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const fetchProblems = (req: Request, res: Response, next: NextFunction) => {
    getContestProblems(req.params.id,  req.query, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const fetchCreator = (req: Request, res: Response, next: NextFunction) => {
    getContesCreator(req.params.id, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  const findContestInfo = (req: Request, res: Response, next: NextFunction) => {
    getContestInfo(req.params.id, dbRepository)
      .then((contest) => res.json(contest))
      .catch((error) => next(error));
  }

  return {
    fetchContestById,
    fetchAllContests,
    createNewContest,
    updateExistingContest,
    deleteContest,
    addProblem,
    removeProblem,
    addParticipant,
    removeParticipant,
    fetchParticipants,
    fetchProblems,
    fetchCreator,
    findContestInfo,
  };
}
